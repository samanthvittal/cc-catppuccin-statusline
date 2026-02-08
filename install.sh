#!/bin/bash

# Install Catppuccin Status Line for Claude Code
# https://github.com/samanthvittal/cc-catppuccin-statusline

set -e

INSTALL_DIR="${HOME}/.claude/scripts/catppuccin"
SETTINGS_FILE="${HOME}/.claude/settings.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing Catppuccin status line for Claude Code..."

# Create install directories
mkdir -p "${INSTALL_DIR}/themes"

# Copy status line script
cp "${SCRIPT_DIR}/status-line.sh" "${INSTALL_DIR}/status-line.sh"
chmod +x "${INSTALL_DIR}/status-line.sh"

# Copy theme files
cp "${SCRIPT_DIR}/themes/"*.sh "${INSTALL_DIR}/themes/"

# Copy theme switcher script
cp "${SCRIPT_DIR}/switch-theme.sh" "${INSTALL_DIR}/switch-theme.sh"
chmod +x "${INSTALL_DIR}/switch-theme.sh"

# Set default theme (Frappe)
cp "${INSTALL_DIR}/themes/frappe.sh" "${INSTALL_DIR}/theme.sh"

# Update settings.json
if [ -f "$SETTINGS_FILE" ]; then
  if command -v jq &>/dev/null; then
    tmp=$(mktemp)
    jq '.statusLine = {"type": "command", "command": "~/.claude/scripts/catppuccin/status-line.sh"}' \
      "$SETTINGS_FILE" > "$tmp" && mv "$tmp" "$SETTINGS_FILE"
  else
    echo ""
    echo "Warning: jq not found. Please add this to ~/.claude/settings.json manually:"
    echo '  "statusLine": { "type": "command", "command": "~/.claude/scripts/catppuccin/status-line.sh" }'
  fi
else
  mkdir -p "${HOME}/.claude"
  cat > "$SETTINGS_FILE" <<'EOF'
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/scripts/catppuccin/status-line.sh"
  }
}
EOF
fi

echo ""
echo "Installed to: ${INSTALL_DIR}/"
echo "Default theme: Frappe"
echo ""
echo "To switch themes:"
echo "  ${INSTALL_DIR}/switch-theme.sh <flavor>"
echo "  Flavors: frappe, latte, macchiato, mocha"
echo ""
echo "Restart Claude Code to apply."
