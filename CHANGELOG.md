# Changelog

All notable changes to Daywalker will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2024-12-21

### Added

- Initial release
- Dark and light theme variants (Tokyo Night inspired)
- Session dots display with current session name
- Modular status bar architecture
- Built-in modules:
  - `mode` - Normal/Prefix mode indicator
  - `session` - Session name with dots
  - `datetime` - Configurable date/time display
  - `git` - Git branch and status
  - `battery` - Battery level (macOS/Linux)
  - `host` - Hostname display
  - `user` - Username display
  - `jobs` - Suspended jobs count indicator
  - `ssh` - SSH session indicator with hostname
- Window indicators:
  - Bell indicator (󰂞) - shows when window has bell
  - Activity indicator (󰋼) - shows when window has new output
  - Zoom indicator (󰁌) - shows when pane is zoomed
- Full configuration via tmux options:
  - `@daywalker_variant` - Theme variant (dark/light)
  - `@daywalker_session_icon` - Custom session icon
  - `@daywalker_show_session_dots` - Toggle session dots
  - `@daywalker_window_separator` - Window format separator
  - `@daywalker_show_window_number` - Toggle window numbers
  - `@daywalker_status_left` - Left status modules
  - `@daywalker_status_right` - Right status modules
  - `@daywalker_date_format` - Date format string
  - `@daywalker_time_format` - Time format string
- tmux-dark-notify integration for automatic theme switching
- TPM (Tmux Plugin Manager) support
- Comprehensive documentation
- CI/CD with GitHub Actions

### Changed

- N/A

### Deprecated

- N/A

### Removed

- N/A

### Fixed

- N/A

### Security

- N/A
