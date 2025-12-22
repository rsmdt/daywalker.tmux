# Contributing to Daywalker

Thanks for your interest in contributing to Daywalker! This document provides guidelines and information for contributors.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a new branch for your feature or fix

## Development Setup

### Requirements

- tmux >= 3.2
- bash >= 4.0
- A Nerd Font for icon testing

### Local Testing

```bash
# Link the theme to your tmux plugins
ln -s /path/to/daywalker.tmux ~/.config/tmux/plugins/daywalker.tmux

# Reload tmux configuration
tmux source ~/.config/tmux/tmux.conf

# Test theme switching
~/.config/tmux/plugins/daywalker.tmux/scripts/daywalker.sh dark
~/.config/tmux/plugins/daywalker.tmux/scripts/daywalker.sh light
```

## Project Structure

```
daywalker.tmux
├── daywalker.tmux          # TPM entry point
├── daywalker-dark.conf     # Dark mode wrapper for tmux-dark-notify
├── daywalker-light.conf    # Light mode wrapper for tmux-dark-notify
├── scripts/
│   ├── daywalker.sh        # Main orchestrator
│   ├── core/               # Core theme logic (split for maintainability)
│   │   ├── config.sh       # Configuration loading
│   │   ├── status.sh       # Status bar building
│   │   └── apply.sh        # Apply tmux settings
│   └── modules/            # Status bar modules
│       ├── battery.sh
│       ├── datetime.sh
│       ├── git.sh
│       └── session.sh      # Session dots display
├── themes/
│   ├── dark.sh             # Dark color palette
│   └── light.sh            # Light color palette
├── utils/
│   └── helpers.sh          # Shared helper functions
└── docs/                   # Documentation
```

## Code Style

### Shell Scripts

- Use `#!/usr/bin/env bash` shebang
- Use `set -e` for error handling
- Quote all variables: `"${variable}"`
- Use meaningful variable names
- Add comments for complex logic

### Naming Conventions

- Files: lowercase with hyphens (`my-module.sh`)
- Functions: lowercase with underscores (`my_function`)
- Variables: lowercase with underscores (`my_variable`)
- tmux options: prefix with `@daywalker_`

## Making Changes

### Adding a New Module

1. Create the module script in `scripts/modules/`
2. Make it executable: `chmod +x scripts/modules/mymodule.sh`
3. Register it in `scripts/daywalker.sh`
4. Document it in `docs/modules.md`
5. Update README.md with the new module

### Modifying Colors

1. Update the relevant theme file in `themes/`
2. Update the color table in README.md
3. Update `docs/colors.md`

### Adding Configuration Options

1. Add the option in `scripts/daywalker.sh` using `get_tmux_option`
2. Document it in `docs/configuration.md`
3. Update README.md

## Testing

Before submitting:

1. **Syntax check**: `bash -n script.sh`
2. **ShellCheck**: `shellcheck script.sh`
3. **Manual testing**: Test in tmux with both dark and light modes
4. **Module testing**: Verify modules work in different contexts

## Pull Request Process

1. Update documentation for any new features
2. Ensure all scripts pass shellcheck
3. Test your changes locally
4. Write a clear PR description explaining:
   - What the change does
   - Why it's needed
   - How to test it

## Reporting Issues

When reporting issues, please include:

- tmux version (`tmux -V`)
- Terminal emulator
- Operating system
- Steps to reproduce
- Expected vs actual behavior

## Adding New Color Themes

We welcome new color theme contributions! To add a theme:

1. Create `themes/mytheme.sh` with all required color variables
2. Add the theme case to `scripts/daywalker.sh`
3. Create a preview screenshot
4. Document the colors in your PR

Required color variables:
- `bg`, `fg`, `fg_muted`
- `primary`, `warning`, `accent`, `success`
- `border`
- `contrast` (optional, for light themes)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
