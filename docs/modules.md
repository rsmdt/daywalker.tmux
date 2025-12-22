# Status Modules

Daywalker uses a modular architecture for status bar components. Each module is a standalone shell script that outputs tmux-formatted text.

## Built-in Modules

### Mode (`mode`)

Displays the current tmux mode:
- `[N]` - Normal mode (primary color)
- `[P]` - Prefix mode (warning color)

### Session (`session`)

Displays session information:
- With dots: `󰆧 CurrentSession • • •`
- Without dots: `󰆧 CurrentSession`

Controlled by `@daywalker_show_session_dots`.

Location: `scripts/modules/session.sh`

### DateTime (`datetime`)

Displays current date and time using configured formats.

Location: `scripts/modules/datetime.sh`

### Git (`git`)

Displays git repository status:
- Branch name with  icon
- `+N` - Staged changes (green)
- `~N` - Modified files (yellow)
- `?N` - Untracked files (muted)

Location: `scripts/modules/git.sh`

### Battery (`battery`)

Displays battery status with appropriate icons:
- 󰂄 - Charging
- 󰁹 - Full (80-100%)
- 󰂀 - Good (60-80%)
- 󰁾 - Medium (40-60%)
- 󰁼 - Low (20-40%)
- 󰁺 - Critical (<20%, warning color)

Location: `scripts/modules/battery.sh`

### Host (`host`)

Displays the hostname using tmux's `#H` variable.

### User (`user`)

Displays the current username.

### Jobs (`jobs`)

Displays count of suspended/background jobs in the current pane. Shows only when there are suspended processes (via Ctrl+Z).

- Icon: `󰏤` with count
- Color: Warning color when jobs exist

Location: `scripts/modules/jobs.sh`

**Why it's useful**: Reminds you about forgotten suspended processes that may be using resources.

### SSH (`ssh`)

Displays an indicator when you're connected via SSH, showing the remote hostname.

- Icon: `󰣀` with hostname
- Color: Warning color (to draw attention)
- Only visible when in SSH session

Location: `scripts/modules/ssh.sh`

**Why it's useful**: Prevents accidentally running destructive commands on remote servers.

## Window Indicators

In addition to status modules, Daywalker adds visual indicators to window tabs:

### Bell Indicator (`󰂞`)
Shows when a window has triggered a bell (e.g., command completion notification).

### Activity Indicator (`󰋼`)
Shows when a window has new output/activity.

### Zoom Indicator (`󰁌`)
Shows when the current pane is zoomed.

These indicators appear automatically on inactive windows and require no configuration.

## Creating Custom Modules

### Module Structure

Modules are bash scripts in `scripts/modules/` that:
1. Accept color arguments
2. Output tmux-formatted text
3. Exit cleanly if data is unavailable

### Template

```bash
#!/usr/bin/env bash
# Daywalker Theme - Custom Module
# Usage: mymodule.sh <fg_color> <other_colors...>

fg="${1:-#a1aab8}"

# Your logic here
result="my data"

# Output with tmux formatting
echo "#[fg=${fg}] ${result} "
```

### Best Practices

1. **Fast execution**: Modules run on every status update
2. **Handle missing data**: Exit cleanly if data unavailable
3. **Use colors consistently**: Accept colors as arguments
4. **Include icon**: Use Nerd Font icons when appropriate

### Example: Custom Weather Module

```bash
#!/usr/bin/env bash
# weather.sh <fg_color>

fg="${1:-#a1aab8}"

# Cache weather for 30 minutes
cache_file="/tmp/daywalker_weather"
cache_age=1800

if [[ -f "$cache_file" ]]; then
    age=$(($(date +%s) - $(stat -f %m "$cache_file")))
    if [[ $age -lt $cache_age ]]; then
        cat "$cache_file"
        exit 0
    fi
fi

# Fetch weather (example with wttr.in)
weather=$(curl -s "wttr.in/?format=%c%t" 2>/dev/null)

if [[ -n "$weather" ]]; then
    output="#[fg=${fg}]${weather} "
    echo "$output" | tee "$cache_file"
fi
```

### Registering Custom Modules

Add your module to the module loader in `scripts/daywalker.sh`:

```bash
case "$module" in
    # ... existing modules ...
    weather)
        if [[ -x "${SCRIPT_DIR}/modules/weather.sh" ]]; then
            output+="#(${SCRIPT_DIR}/modules/weather.sh '${fg}')"
        fi
        ;;
esac
```

Then use it in your config:

```bash
set -g @daywalker_status_right 'weather,datetime'
```

## Module Arguments

Most modules accept colors as arguments in this order:

| Argument | Description |
|----------|-------------|
| `$1` | Primary/foreground color |
| `$2` | Muted/secondary color |
| `$3` | Success color |
| `$4` | Warning color |

Example call from daywalker.sh:
```bash
output+="#(${SCRIPT_DIR}/modules/git.sh '${fg}' '${fg_muted}' '${success}' '${warning}')"
```
