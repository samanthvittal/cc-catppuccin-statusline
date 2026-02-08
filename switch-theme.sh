#!/bin/bash

# Switch Catppuccin flavor for Claude Code status line
# Usage: switch-theme.sh <flavor>
# Flavors: frappe, latte, macchiato, mocha
# https://github.com/samanthvittal/cc-catppuccin-statusline

INSTALL_DIR="${HOME}/.claude/scripts/catppuccin"
FLAVOR="${1,,}" # lowercase

if [ -z "$FLAVOR" ]; then
  echo "Usage: switch-theme.sh <flavor>"
  echo "Flavors: frappe, latte, macchiato, mocha"
  exit 1
fi

case "$FLAVOR" in
  frappe|latte|macchiato|mocha) ;;
  *)
    echo "Error: Unknown flavor '${1}'."
    echo "Available flavors: frappe, latte, macchiato, mocha"
    exit 1
    ;;
esac

if [ ! -d "${INSTALL_DIR}/themes" ]; then
  echo "Error: Catppuccin status line not installed. Run install.sh first."
  exit 1
fi

if [ ! -f "${INSTALL_DIR}/themes/${FLAVOR}.sh" ]; then
  echo "Error: Theme file not found: ${INSTALL_DIR}/themes/${FLAVOR}.sh"
  exit 1
fi

cp "${INSTALL_DIR}/themes/${FLAVOR}.sh" "${INSTALL_DIR}/theme.sh"
echo "Switched to Catppuccin ${FLAVOR^}."
echo "Restart Claude Code to apply."
