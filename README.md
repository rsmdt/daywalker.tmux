# 🌗 Daywalker for tmux

A minimal, modular tmux theme with dark/light mode support and a popup menu.

## Features

- **Dark/Light modes** - Seamless switching based on system appearance
- **Modular status bar** - Compose your status bar from available modules
- **Popup menu** - Quick access to common operations
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

Modules can be placed in `status-left` or `status-right`. The window list is positioned using `@daywalker_window_position`.

| Module | Description | Example |
|--------|-------------|---------|
| `mode` | Normal/Prefix indicator | `[N]` `[P]` |
| `session` | Session name with optional dots | `󰆧 main • •` |
| `datetime` | Date and time | `2024-12-22 14:30` |
| `git` | Branch and status | ` main +2 ~1` |
| `battery` | Battery percentage | ` 85%` |
| `host` | Hostname | `macbook` |
| `user` | Username | `rsmdt` |
| `jobs` | Suspended job count | `⏸ 2` |
| `ssh` | SSH session indicator | ` server` |
| `menu` | Clickable menu icon | `☰` |

## Menu

Open the popup menu with either method:
- **Right-click** anywhere on the status bar
- **Press `M-Up`** (Alt+Up arrow, configurable)

Destructive operations (kill window/session) require confirmation.

Menu includes:
- Window operations (new, rename, kill)
- Pane operations (split all directions, break, kill)
- Session operations (new, rename, choose, kill)
- Show keybindings

## Default Configuration

```bash
set -g @daywalker_variant 'dark'                  # 'dark' or 'light'

# Status bar modules
set -g @daywalker_status_left 'mode,session'      # Left modules
set -g @daywalker_status_right ''                 # Right modules (empty by default)
set -g @daywalker_window_position 'right'         # Window list position: left, centre, right

# Session & Window
set -g @daywalker_session_icon '󰆧'
set -g @daywalker_show_session_dots 'true'
set -g @daywalker_window_separator '|'
set -g @daywalker_show_window_number 'true'
set -g @daywalker_date_format '%Y-%m-%d'
set -g @daywalker_time_format '%H:%M'

# Menu
set -g @daywalker_menu 'true'                     # Enable popup menu
set -g @daywalker_menu_key 'M-Up'                 # Menu trigger key
set -g @daywalker_menu_click 'true'               # Right-click status bar for menu
```

## Suggested Keybindings

Daywalker focuses on theming. Add these vim-style keybindings to your `.tmux.conf` if desired:

```bash
# Vim-style pane splitting (prefix + h/j/k/l)
bind-key h split-window -hb -c "#{pane_current_path}"  # Split left
bind-key l split-window -h -c "#{pane_current_path}"   # Split right
bind-key k split-window -vb -c "#{pane_current_path}"  # Split up
bind-key j split-window -v -c "#{pane_current_path}"   # Split down

# Window navigation (no prefix needed)
bind-key -n M-h previous-window
bind-key -n M-l next-window
bind-key -n M-Left previous-window
bind-key -n M-Right next-window

# Swap windows
bind-key -n S-M-Left run "tmux swap-window -d -t #{e|-|:#I,1}"
bind-key -n S-M-Right run "tmux swap-window -d -t #{e|+|:#I,1}"

# Quick actions (no prefix needed)
bind-key -n M-x kill-pane
bind-key -n M-s choose-tree
bind-key -n M-c new-window -c "#{pane_current_path}"
bind-key -n M-n new-session
```

> **Tip:** For a more powerful keybinding experience with which-key style popups, check out [tmux-which-key](https://github.com/alexwforsythe/tmux-which-key).

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
