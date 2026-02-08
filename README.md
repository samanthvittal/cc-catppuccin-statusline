# Catppuccin Status Line for Claude Code

A [Catppuccin](https://github.com/catppuccin/catppuccin)-themed status line for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

```
 Opus 4.6 ●  main* ●  my-project ●  120/200k ●  60% ●  2h15m
```

## Flavors

All four Catppuccin flavors are supported:

| Flavor | Description |
|--------|-------------|
| **Frappe** | Dark theme (default) |
| **Latte** | Light theme |
| **Macchiato** | Dark theme |
| **Mocha** | Dark theme |

## Modules

| Module | Icon | Color | Description |
|--------|------|-------|-------------|
| Model |  | Lavender | Current Claude model (`Opus 4.6`, `Sonnet 4.5`, etc.) |
| Branch |  | Mauve | Git branch name + `*` dirty indicator (Peach) |
| Folder |  | Teal | Current working directory name |
| Tokens |  | Blue/Yellow/Red | Context window usage (`120/200k` format) |
| Context % |  | Blue/Yellow/Red | Percentage of context used before auto-compact |
| Duration |  | Subtext | Session duration |

Context colors change based on usage:
- **Blue** - 0-50% (comfortable)
- **Yellow** - 51-70% (warming up)
- **Red** - 71-100% (approaching auto-compact)

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- `jq` (JSON processor)
- A terminal with true color (24-bit) support
- A [Nerd Font](https://www.nerdfonts.com/) (required for icons to display correctly)

## Installation

```bash
git clone https://github.com/samanthvittal/cc-catppuccin-statusline.git
cd cc-catppuccin-statusline
./install.sh
```

This will:
1. Copy all scripts to `~/.claude/scripts/catppuccin/`
2. Set **Frappe** as the default theme
3. Update `~/.claude/settings.json` to use the status line

Restart Claude Code after installing.

## Switching Themes

```bash
~/.claude/scripts/catppuccin/switch-theme.sh <flavor>
```

Available flavors: `frappe`, `latte`, `macchiato`, `mocha`

Restart Claude Code after switching.

## Project Structure

```
cc-catppuccin-statusline/
├── status-line.sh          # Main status line script
├── themes/
│   ├── frappe.sh           # Frappe color definitions
│   ├── latte.sh            # Latte color definitions
│   ├── macchiato.sh        # Macchiato color definitions
│   └── mocha.sh            # Mocha color definitions
├── switch-theme.sh         # Switch between flavors
├── install.sh              # Installation script
├── LICENSE
└── README.md
```

## Manual Configuration

If you prefer to set things up manually, add this to `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/scripts/catppuccin/status-line.sh"
  }
}
```

## License

[MIT](LICENSE)
