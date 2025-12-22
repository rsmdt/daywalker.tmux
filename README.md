# 🌗 Daywalker for tmux

A minimal, modular tmux theme with dark/light mode support, vim-style keybindings, and a popup menu.

## Features

- **Dark/Light modes** - Seamless switching based on system appearance
- **Modular status bar** - Compose your status bar from available modules
- **Vim-style keybindings** - Intuitive pane splitting and navigation
- **Popup menu** - Quick access to common operations (`M-Up`)
- **Fully configurable** - Customize via tmux options
- **Nerd Font icons** - Clean, modern appearance

## Requirements

- tmux >= 3.2
- A [Nerd Font](https://www.nerdfonts.com/)

## Installation

### TPM (recommended)

```bash
set -g @plugin 'rsmdt/daywalker.tmux'
```

Then press `prefix + I` to install.

### Manual

```bash
git clone https://github.com/rsmdt/daywalker.tmux ~/.config/tmux/plugins/daywalker.tmux
```

```bash
run-shell ~/.config/tmux/plugins/daywalker.tmux/daywalker.tmux
```

## Modules

Modules can be placed in `status-left`, `status-right`, or `status-centre`.

| Module | Description | Example |
|--------|-------------|---------|
| `mode` | Normal/Prefix indicator | `[N]` `[P]` |
| `windows` | Window list | `1:zsh 2:vim 3:node` |
| `session` | Session name with optional dots | `󰆧 main • •` |
| `datetime` | Date and time | `2024-12-22 14:30` |
| `git` | Branch and status | ` main +2 ~1` |
| `battery` | Battery percentage | ` 85%` |
| `host` | Hostname | `macbook` |
| `user` | Username | `rsmdt` |
| `jobs` | Suspended job count | `⏸ 2` |
| `ssh` | SSH session indicator | ` server` |
| `menu` | Clickable menu icon | `☰` |

## Keybindings

### Vim-style Pane Splitting (prefix + key)

| Key | Action |
|-----|--------|
| `h` | Split pane left |
| `j` | Split pane down |
| `k` | Split pane up |
| `l` | Split pane right |

### Quick Actions (no prefix needed)

| Key | Action |
|-----|--------|
| `M-h` / `M-Left` | Previous window |
| `M-l` / `M-Right` | Next window |
| `S-M-Left` | Swap window left |
| `S-M-Right` | Swap window right |
| `M-x` | Kill pane |
| `M-s` | Choose session |
| `M-c` | New window |
| `M-n` | New session |
| `M-Up` | Open menu |

### Menu

Open the popup menu with any of these methods:
- **Left-click** on the mode indicator `[N]`/`[P]` (status-left area)
- **Right-click** anywhere on the status bar
- **Press `M-Up`** (Alt+Up arrow)

Menu includes:
- Window operations (new, rename, kill)
- Pane operations (split all directions, break, kill)
- Session operations (new, rename, choose, kill)
- Help (show keybindings)

## Default Configuration

```bash
set -g @daywalker_variant 'dark'                  # 'dark' or 'light'

set -g @daywalker_status-left 'mode,session'      # Left modules
set -g @daywalker_status-centre 'windows'         # Centre modules
set -g @daywalker_status-right 'datetime'         # Right modules

# Session & Window
set -g @daywalker_session_icon '󰆧'
set -g @daywalker_show_session_dots 'true'
set -g @daywalker_window_separator '|'
set -g @daywalker_show_window_number 'true'
set -g @daywalker_date_format '%Y-%m-%d'
set -g @daywalker_time_format '%H:%M'

# Keybindings & Menu
set -g @daywalker_keybindings 'true'              # Enable vim-style keybindings
set -g @daywalker_menu 'true'                     # Enable popup menu
set -g @daywalker_menu_key 'M-Up'                 # Menu trigger key
set -g @daywalker_menu_click 'true'               # Right-click status bar for menu
set -g @daywalker_menu_icon '☰'                   # Menu icon in status bar
```

## Keybinding Configuration

All keybindings can be customized:

```bash
# Pane splitting (prefix + key)
set -g @daywalker_key_split_left 'h'
set -g @daywalker_key_split_right 'l'
set -g @daywalker_key_split_up 'k'
set -g @daywalker_key_split_down 'j'

# Window navigation (no prefix)
set -g @daywalker_key_prev_window 'M-h'
set -g @daywalker_key_next_window 'M-l'
set -g @daywalker_key_swap_window_left 'S-M-Left'
set -g @daywalker_key_swap_window_right 'S-M-Right'

# Quick actions (no prefix)
set -g @daywalker_key_kill_pane 'M-x'
set -g @daywalker_key_choose_tree 'M-s'
set -g @daywalker_key_new_window 'M-c'
set -g @daywalker_key_new_session 'M-n'

# Disable keybindings entirely
set -g @daywalker_keybindings 'false'
```

## Theme Switching

### Runtime Switching

Switch themes without editing your config:

```bash
# Toggle between dark and light
~/.tmux/plugins/daywalker.tmux/scripts/switch-theme.sh toggle

# Switch to specific theme
~/.tmux/plugins/daywalker.tmux/scripts/switch-theme.sh dark
~/.tmux/plugins/daywalker.tmux/scripts/switch-theme.sh light
```

Optional keybinding for quick toggling:

```bash
bind-key T run-shell '~/.tmux/plugins/daywalker.tmux/scripts/switch-theme.sh toggle'
```

### Auto Dark/Light Switching (macOS)

With [tmux-dark-notify](https://github.com/erikw/tmux-dark-notify):

```bash
# TPM installs plugins to ~/.tmux/plugins/
set -g @plugin 'erikw/tmux-dark-notify'
set -g @dark-notify-theme-path-light '~/.tmux/plugins/daywalker.tmux/daywalker-light.conf'
set -g @dark-notify-theme-path-dark '~/.tmux/plugins/daywalker.tmux/daywalker-dark.conf'
```

> **Note:** If you installed to a different location (e.g., `~/.config/tmux/plugins/`), adjust the paths accordingly.

## Color Variables

Daywalker exposes theme colors as tmux options for use in your own configuration:

| Variable | Description |
|----------|-------------|
| `@daywalker_color_bg` | Background color |
| `@daywalker_color_fg` | Foreground color |
| `@daywalker_color_fg_muted` | Muted/secondary text |
| `@daywalker_color_primary` | Primary accent (normal mode) |
| `@daywalker_color_accent` | Highlight accent (active elements) |
| `@daywalker_color_warning` | Warning color (prefix mode) |
| `@daywalker_color_success` | Success color (messages) |
| `@daywalker_color_border` | Border color |
| `@daywalker_color_contrast` | Text on colored backgrounds |

Example usage:

```bash
# Use daywalker colors in your own styling
set -g popup-border-style "fg=#{@daywalker_color_border}"
```

## Documentation

- [Configuration Reference](docs/configuration.md)
- [Modules](docs/modules.md)
- [Colors](docs/colors.md)

## License

MIT
