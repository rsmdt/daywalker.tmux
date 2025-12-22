# Color Customization

Daywalker's colors are defined in theme files located in `themes/`.

## Theme Files

- `themes/dark.sh` - Dark mode colors
- `themes/light.sh` - Light mode colors

## Color Variables

Each theme defines these color variables:

| Variable | Purpose | Usage |
|----------|---------|-------|
| `bg` | Background | Status bar, messages |
| `fg` | Foreground | Primary text |
| `fg_muted` | Muted foreground | Inactive elements, secondary text |
| `primary` | Primary accent | Normal mode indicator |
| `warning` | Warning accent | Prefix mode, low battery |
| `accent` | Highlight accent | Active window |
| `success` | Success accent | Messages, git staged |
| `border` | Border color | Pane borders |
| `contrast` | Contrast color | Text on colored backgrounds |

## Dark Theme

File: `themes/dark.sh`

```bash
# Tokyo Night Moon inspired
bg="#12131d"
fg="#a1aab8"
fg_muted="#545c7e"
primary="#6cbdcc"
warning="#ffc777"
accent="#fa50c0"
success="#c3e88d"
border="#2d3041"
```

## Light Theme

File: `themes/light.sh`

```bash
# Tokyo Night Day inspired
bg="#b4b5b9"
fg="#3760bf"
fg_muted="#6172b0"
primary="#007197"
warning="#8c6c3e"
accent="#9854f1"
success="#587539"
border="#a8aecb"
contrast="#ffffff"  # For text on colored backgrounds
```

## Creating Custom Themes

### Option 1: Modify Existing Themes

Edit the theme files directly:

```bash
# themes/dark.sh
bg="#1a1b26"      # Your custom background
fg="#c0caf5"      # Your custom foreground
# ... etc
```

### Option 2: Create New Theme Variants

1. Create a new theme file:

```bash
# themes/monokai.sh
bg="#272822"
fg="#f8f8f2"
fg_muted="#75715e"
primary="#66d9ef"
warning="#e6db74"
accent="#f92672"
success="#a6e22e"
border="#3e3d32"
```

2. Modify `scripts/daywalker.sh` to load it:

```bash
case "$MODE" in
    monokai)
        source "${THEME_DIR}/monokai.sh"
        ;;
    light)
        source "${THEME_DIR}/light.sh"
        ;;
    *)
        source "${THEME_DIR}/dark.sh"
        ;;
esac
```

3. Use in your config:

```bash
set -g @daywalker_variant 'monokai'
```

## Color Contrast

The `contrast` variable is used for text that appears on colored backgrounds (like the active window).

- **Dark themes**: Usually don't need `contrast` (defaults to `bg`)
- **Light themes**: Set to white or a light color for readability

```bash
# Light theme
contrast="#ffffff"  # White text on colored backgrounds
```

## Testing Colors

After modifying colors, reload tmux:

```bash
tmux source ~/.config/tmux/tmux.conf
```

Or manually switch themes:

```bash
# In tmux
:run-shell "~/.config/tmux/plugins/daywalker.tmux/scripts/daywalker.sh dark"
```

## Color Tools

Useful resources for choosing colors:

- [Coolors](https://coolors.co/) - Color palette generator
- [Color Hunt](https://colorhunt.co/) - Color palettes
- [Terminal.sexy](https://terminal.sexy/) - Terminal color schemes
- [Tokyo Night](https://github.com/folke/tokyonight.nvim) - Original inspiration

## Accessibility

When customizing colors, ensure:

1. **Sufficient contrast**: Text should be readable on backgrounds
2. **Distinguishable states**: Active vs inactive elements should be clearly different
3. **Color-blind friendly**: Don't rely solely on red/green distinction
