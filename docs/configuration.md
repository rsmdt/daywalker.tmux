# Configuration Reference

All Daywalker options use the `@daywalker_` prefix and should be set before the plugin loads.

## Theme Options

### `@daywalker_variant`

Sets the theme variant.

| Value | Description |
|-------|-------------|
| `dark` | Dark theme (default) |
| `light` | Light theme |

```bash
set -g @daywalker_variant 'dark'
```

## Session Options

### `@daywalker_session_icon`

Icon displayed before the session list.

- **Default:** `󰆧` (layers icon)
- **Type:** String (any single character or Nerd Font icon)

```bash
set -g @daywalker_session_icon ''  # Alternative session icon
```

### `@daywalker_show_session_dots`

Show other sessions as dots (•) with current session name displayed.

| Value | Description |
|-------|-------------|
| `true` | Show dots for other sessions (default) |
| `false` | Only show current session name |

```bash
set -g @daywalker_show_session_dots 'false'
```

## Window Options

### `@daywalker_window_separator`

Character(s) between window number and name.

- **Default:** `|`
- **Type:** String

```bash
set -g @daywalker_window_separator ':'  # Use colon instead
```

### `@daywalker_show_window_number`

Display window index numbers.

| Value | Description |
|-------|-------------|
| `true` | Show window numbers (default) |
| `false` | Hide window numbers |

```bash
set -g @daywalker_show_window_number 'false'
```

## Status Bar Modules

### `@daywalker_status_left`

Comma-separated list of modules for the left side.

- **Default:** `mode,session`

```bash
set -g @daywalker_status_left 'mode,session,datetime'
```

### `@daywalker_status_right`

Comma-separated list of modules for the right side.

- **Default:** (empty)

```bash
set -g @daywalker_status_right 'git,battery,datetime'
```

### Available Modules

| Module | Description | Notes |
|--------|-------------|-------|
| `mode` | Shows [N] or [P] for normal/prefix mode | Changes color on prefix |
| `session` | Session name with optional dots | Uses session_icon |
| `datetime` | Date and time display | Uses format options |
| `git` | Git branch and status | Shows +staged ~modified ?untracked |
| `battery` | Battery percentage | macOS and Linux support |
| `host` | Hostname | Uses #H |
| `user` | Username | Uses whoami |
| `jobs` | Suspended jobs count | Shows when Ctrl+Z jobs exist |
| `ssh` | SSH session indicator | Shows hostname when in SSH |

## DateTime Options

### `@daywalker_date_format`

Date format string (uses `date` command format).

- **Default:** `%Y-%m-%d`

```bash
set -g @daywalker_date_format '%b %d'     # "Dec 21"
set -g @daywalker_date_format '%a %d %b'  # "Sun 21 Dec"
```

### `@daywalker_time_format`

Time format string (uses `date` command format).

- **Default:** `%H:%M`

```bash
set -g @daywalker_time_format '%I:%M %p'  # "09:30 PM"
set -g @daywalker_time_format '%H:%M:%S'  # "21:30:45"
```

## Complete Example

```bash
# Theme settings
set -g @daywalker_variant 'dark'

# Session settings
set -g @daywalker_session_icon '󰆧'
set -g @daywalker_show_session_dots 'true'

# Window settings
set -g @daywalker_window_separator '|'
set -g @daywalker_show_window_number 'true'

# Status bar modules
set -g @daywalker_status_left 'mode,session'
set -g @daywalker_status_right 'git,battery,datetime'

# DateTime format
set -g @daywalker_date_format '%b %d'
set -g @daywalker_time_format '%H:%M'

# Load the plugin
set -g @plugin 'rsmdt/daywalker.tmux'
```

## With tmux-dark-notify

For automatic theme switching based on macOS system appearance:

```bash
# Daywalker theme
set -g @plugin 'rsmdt/daywalker.tmux'
set -g @daywalker_variant 'dark'  # Initial variant

# Auto-switch with dark-notify
set -g @plugin 'erikw/tmux-dark-notify'
set -g @dark-notify-theme-path-light '$HOME/.config/tmux/plugins/daywalker.tmux/daywalker-light.conf'
set -g @dark-notify-theme-path-dark '$HOME/.config/tmux/plugins/daywalker.tmux/daywalker-dark.conf'
```
