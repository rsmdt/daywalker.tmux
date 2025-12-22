#!/usr/bin/env bash
# Daywalker Theme - Status Bar Building
# Functions to build status-left, status-right, and window formats

# Prevent double-sourcing
[[ -n "$DAYWALKER_STATUS_LOADED" ]] && return 0
export DAYWALKER_STATUS_LOADED=1

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Build Window Format
# └─────────────────────────────────────────────────────────────────────────────
build_window_format() {
    local format=" "

    # Icons first (bell, activity, zoomed) - consistent on all windows, normal text
    format+="#{?window_bell_flag,󰂞 ,}"
    format+="#{?window_activity_flag,󰋼 ,}"
    format+="#{?window_zoomed_flag,󰁌 ,}"

    # Window number (if enabled)
    if [[ "$window_number" == "true" ]]; then
        format+="#I ${window_separator} "
    fi

    # Pane mode indicator and window name
    format+="#{?pane_in_mode,#{pane_mode}  ,}#W "

    echo "$format"
}

# Build format for inactive windows
build_window_format_inactive() {
    build_window_format
}

# Build format for current window (same format for consistency)
build_window_format_current() {
    build_window_format
}

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Build Status Left
# └─────────────────────────────────────────────────────────────────────────────
build_status_left() {
    local output=""
    local modules_dir="${MODULES_DIR}"

    IFS=',' read -ra modules <<< "$status_left_modules"
    for module in "${modules[@]}"; do
        module=$(echo "$module" | xargs) # trim whitespace
        case "$module" in
            mode)
                # Mode indicator [N] or [P]
                output+="#{?client_prefix,#[fg=${bg} bg=${warning} bold] P #[fg=${warning} bg=${bg}],#[fg=${bg} bg=${primary} bold] N #[fg=${primary} bg=${bg}]}"
                ;;
            session)
                if [[ "$show_session_dots" == "true" ]]; then
                    # Session icon with dots
                    output+="#[fg=${fg_muted} bg=${bg} nobold] ${session_icon} #(${modules_dir}/session.sh '#S' '${fg}' '${fg_muted}') "
                else
                    # Just session name
                    output+="#[fg=${fg} bg=${bg} nobold] ${session_icon} #S "
                fi
                ;;
            datetime)
                if [[ -x "${modules_dir}/datetime.sh" ]]; then
                    output+="#(${modules_dir}/datetime.sh '${fg_muted}' '${date_format}' '${time_format}')"
                else
                    output+="#[fg=${fg_muted} bg=${bg}] $(date +"${date_format}") $(date +"${time_format}") "
                fi
                ;;
            git)
                if [[ -x "${modules_dir}/git.sh" ]]; then
                    output+="#(${modules_dir}/git.sh '${fg}' '${fg_muted}' '${success}' '${warning}')"
                fi
                ;;
            battery)
                if [[ -x "${modules_dir}/battery.sh" ]]; then
                    output+="#(${modules_dir}/battery.sh '${fg}' '${warning}' '${success}')"
                fi
                ;;
            host)
                output+="#[fg=${fg_muted} bg=${bg}] #H "
                ;;
            user)
                output+="#[fg=${fg} bg=${bg}] #(whoami) "
                ;;
            jobs)
                if [[ -x "${modules_dir}/jobs.sh" ]]; then
                    output+="#(${modules_dir}/jobs.sh '${fg}' '${warning}')"
                fi
                ;;
            ssh)
                if [[ -x "${modules_dir}/ssh.sh" ]]; then
                    output+="#(${modules_dir}/ssh.sh '${fg}' '${warning}')"
                fi
                ;;
            menu)
                local menu_icon
                menu_icon=$(get_tmux_option "@daywalker_menu_icon" "☰")
                output+="#[fg=${primary} bg=${bg}] ${menu_icon} "
                ;;
        esac
    done

    echo "$output"
}

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Build Status Right
# └─────────────────────────────────────────────────────────────────────────────
build_status_right() {
    local output=""
    local modules_dir="${MODULES_DIR}"

    IFS=',' read -ra modules <<< "$status_right_modules"
    for module in "${modules[@]}"; do
        module=$(echo "$module" | xargs) # trim whitespace
        case "$module" in
            datetime)
                if [[ -x "${modules_dir}/datetime.sh" ]]; then
                    output+="#(${modules_dir}/datetime.sh '${fg_muted}' '${date_format}' '${time_format}')"
                else
                    output+="#[fg=${fg_muted} bg=${bg}] $(date +"${date_format}") $(date +"${time_format}") "
                fi
                ;;
            git)
                if [[ -x "${modules_dir}/git.sh" ]]; then
                    output+="#(${modules_dir}/git.sh '${fg}' '${fg_muted}' '${success}' '${warning}')"
                fi
                ;;
            battery)
                if [[ -x "${modules_dir}/battery.sh" ]]; then
                    output+="#(${modules_dir}/battery.sh '${fg}' '${warning}' '${success}')"
                fi
                ;;
            host)
                output+="#[fg=${fg_muted} bg=${bg}] #H "
                ;;
            user)
                output+="#[fg=${fg} bg=${bg}] #(whoami) "
                ;;
            session)
                if [[ "$show_session_dots" == "true" ]]; then
                    output+="#[fg=${fg_muted} bg=${bg} nobold] ${session_icon} #(${modules_dir}/session.sh '#S' '${fg}' '${fg_muted}') "
                else
                    output+="#[fg=${fg} bg=${bg} nobold] ${session_icon} #S "
                fi
                ;;
            mode)
                output+="#{?client_prefix,#[fg=${bg} bg=${warning} bold] P #[fg=${warning} bg=${bg}],#[fg=${bg} bg=${primary} bold] N #[fg=${primary} bg=${bg}]}"
                ;;
            jobs)
                if [[ -x "${modules_dir}/jobs.sh" ]]; then
                    output+="#(${modules_dir}/jobs.sh '${fg}' '${warning}')"
                fi
                ;;
            ssh)
                if [[ -x "${modules_dir}/ssh.sh" ]]; then
                    output+="#(${modules_dir}/ssh.sh '${fg}' '${warning}')"
                fi
                ;;
            menu)
                local menu_icon
                menu_icon=$(get_tmux_option "@daywalker_menu_icon" "☰")
                output+="#[fg=${primary} bg=${bg}] ${menu_icon} "
                ;;
        esac
    done

    echo "$output"
}
