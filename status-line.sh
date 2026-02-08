#!/bin/bash

# Catppuccin Status Line for Claude Code
# https://github.com/samanthvittal/cc-catppuccin-statusline

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source active theme colors
if [ -f "${SCRIPT_DIR}/theme.sh" ]; then
  source "${SCRIPT_DIR}/theme.sh"
else
  # Fallback: Frappe
  source "${SCRIPT_DIR}/themes/frappe.sh" 2>/dev/null || {
    BLUE='\033[38;2;140;170;238m'
    RED='\033[38;2;231;130;132m'
    TEAL='\033[38;2;129;200;190m'
    MAUVE='\033[38;2;202;158;230m'
    LAVENDER='\033[38;2;186;187;241m'
    PEACH='\033[38;2;239;159;118m'
    GREEN='\033[38;2;166;209;137m'
    YELLOW='\033[38;2;229;200;144m'
    OVERLAY='\033[38;2;115;121;148m'
    SUBTEXT='\033[38;2;165;173;206m'
    RESET='\033[0m'
  }
fi

# ── Icons (Nerd Font) ────────────────────────────
ICON_MODEL=$'\uF2DB'      # nf-fa-microchip
ICON_BRANCH=$'\uE725'     # nf-dev-git_branch
ICON_FOLDER=$'\uF07B'     # nf-fa-folder
ICON_TOKENS=$'\uF1C0'     # nf-fa-database
ICON_CONTEXT=$'\uF200'    # nf-fa-pie_chart
ICON_DURATION=$'\uF017'   # nf-fa-clock_o

# Read JSON from Claude Code via stdin
data=$(cat)

# Extract all values in a single jq call (tab-separated)
IFS=$'\t' read -r model cwd max_ctx used_pct duration_ms <<<"$(echo "$data" | jq -r '[
    (.model.display_name // .model.id // "unknown"),
    (.workspace.current_dir // ""),
    (.context_window.context_window_size // 200000),
    (.context_window.used_percentage // ""),
    (.cost.total_duration_ms // 0)
] | @tsv')"

# ── Folder ────────────────────────────────────────
folder="${cwd##*/}"
[ -z "$folder" ] && folder="?"

# ── Git branch + dirty ────────────────────────────
branch=""
dirty=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch=$(git rev-parse --short HEAD 2>/dev/null)

  # Truncate long branch names
  if [ "${#branch}" -gt 20 ]; then
    branch="${branch:0:19}…"
  fi

  # Check for uncommitted changes
  if [ -n "$(git status --porcelain 2>/dev/null | head -1)" ]; then
    dirty="*"
  fi
fi

# ── Token usage (120/200k) ───────────────────────
if [ -n "$used_pct" ] && [ "$used_pct" != "null" ]; then
  pct=$(printf "%.0f" "$used_pct" 2>/dev/null || echo 0)
  [ "$pct" -gt 100 ] 2>/dev/null && pct=100

  used_k=$((max_ctx * pct / 100 / 1000))
  max_k=$((max_ctx / 1000))

  # Color based on usage threshold
  if [ "$pct" -gt 70 ]; then
    CTX_COLOR="$RED"
  elif [ "$pct" -gt 50 ]; then
    CTX_COLOR="$YELLOW"
  else
    CTX_COLOR="$BLUE"
  fi

  token_display="${CTX_COLOR}${ICON_TOKENS} ${used_k}/${max_k}k${RESET}"
  pct_display="${CTX_COLOR}${ICON_CONTEXT} ${pct}%${RESET}"
else
  token_display="${OVERLAY}${ICON_TOKENS} 0/${max_ctx:+$((max_ctx / 1000))}k${RESET}"
  pct_display="${OVERLAY}${ICON_CONTEXT} 0%${RESET}"
fi

# ── Session duration ──────────────────────────────
if [ -n "$duration_ms" ] && [ "$duration_ms" != "0" ] && [ "$duration_ms" != "null" ]; then
  duration_s=$((duration_ms / 1000))
  hours=$((duration_s / 3600))
  minutes=$(( (duration_s % 3600) / 60 ))

  if [ "$hours" -gt 0 ]; then
    time_display="${SUBTEXT}${ICON_DURATION} ${hours}h${minutes}m${RESET}"
  else
    time_display="${SUBTEXT}${ICON_DURATION} ${minutes}m${RESET}"
  fi
else
  time_display="${SUBTEXT}${ICON_DURATION} 0m${RESET}"
fi

# ── Build output ──────────────────────────────────
SEP=" ${OVERLAY}●${RESET} "

output="${LAVENDER}${ICON_MODEL} ${model}${RESET}"

if [ -n "$branch" ]; then
  output="${output}${SEP}${MAUVE}${ICON_BRANCH} ${branch}${RESET}"
  [ -n "$dirty" ] && output="${output}${PEACH}${dirty}${RESET}"
fi

output="${output}${SEP}${TEAL}${ICON_FOLDER} ${folder}${RESET}"
output="${output}${SEP}${token_display}"
output="${output}${SEP}${pct_display}"
output="${output}${SEP}${time_display}"

printf '%b\n' "$output"
