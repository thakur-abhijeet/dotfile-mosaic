# ╔══════════════════════════════════════════╗
# ║   done.fish — Command Completion         ║
# ║   Notifications for Fish Shell           ║
# ║   MIT · Francisco Lourenço & D. Wehner   ║
# ║   Refactored: Abhijeet · CachyOS+Ubuntu  ║
# ╚══════════════════════════════════════════╝
# Location: ~/.config/fish/conf.d/done.fish
# Auto-sourced by fish — do not source manually

# =============================================================================
# Guard: Interactive shells only
# =============================================================================
if not status is-interactive
    exit
end

# =============================================================================
# Plugin Metadata
# =============================================================================
set -g __done_version 1.19.1

# =============================================================================
# Defaults
# =============================================================================
set -q __done_enabled               || set -g __done_enabled               1
set -q __done_min_cmd_duration      || set -g __done_min_cmd_duration      5000
set -q __done_notify_sound          || set -g __done_notify_sound          0
set -q __done_notification_duration || set -g __done_notification_duration 3000
set -q __done_allow_nongraphical    || set -g __done_allow_nongraphical    0

# Notify on push/pull/fetch/clone — skip short git commands
set -q __done_exclude || set -g __done_exclude '^git (?!push|pull|fetch|clone)'

# =============================================================================
# Helper: PowerShell runner (WSL only)
# =============================================================================
function __done_run_powershell_script
    set -l powershell_exe (command --search powershell.exe 2>/dev/null)

    if test $status -ne 0
        if command --search wslvar &>/dev/null
            set powershell_exe \
                (wslpath (wslvar windir)/System32/WindowsPowerShell/v1.0/powershell.exe)
        end
    end

    if string length --quiet "$powershell_exe"; and test -x "$powershell_exe"
        eval "$powershell_exe -Command "(string escape $argv)
    end
end

# =============================================================================
# Windows Toast Notification
# =============================================================================
function __done_windows_notification -a title -a message
    set -l soundopt '<audio silent="true" />'

    if test "$__done_notify_sound" -eq 1
        set soundopt '<audio silent="false" src="ms-winsoundevent:Notification.Default" />'
    end

    __done_run_powershell_script "
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
\$toast_xml_source = @\"
<toast>
  $soundopt
  <visual>
    <binding template=\"ToastText02\">
      <text id=\"1\">$title</text>
      <text id=\"2\">$message</text>
    </binding>
  </visual>
</toast>
\"@
\$toast_xml = New-Object Windows.Data.Xml.Dom.XmlDocument
\$toast_xml.loadXml(\$toast_xml_source)
\$toast = New-Object Windows.UI.Notifications.ToastNotification \$toast_xml
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier(\"fish\").Show(\$toast)
"
end

# =============================================================================
# Focused Window ID Detection
# Priority: macOS → Hyprland → Niri → Sway → X11 → WSL → nongraphical
# =============================================================================
function __done_get_focused_window_id

    if type -q lsappinfo
        # macOS
        lsappinfo info -only bundleID \
            (lsappinfo front | string replace 'ASN:0x0-' '0x') \
            | cut -d '"' -f4

    else if test -n "$HYPRLAND_INSTANCE_SIGNATURE"; and type -q hyprctl
        # Hyprland — CachyOS
        hyprctl activewindow -j | string match -r '"pid":\s*(\d+)' | tail -1

    else if test -n "$NIRI_SOCKET"; and type -q niri
        # Niri — Ubuntu office laptop
        niri msg focused-window | string match -r 'id: (\d+)' | tail -1

    else if test -n "$SWAYSOCK"; and type -q swaymsg; and type -q jq
        # Sway
        swaymsg --type get_tree \
            | jq '.. | objects | select(.focused == true) | .id'

        #else if test -n "$DISPLAY"; and test -z "$WAYLAND_DISPLAY"; and type -q xdotool
        # Pure X11 only — guard against Wayland+XWayland confusion
        #xdotool getactivewindow

    else if uname -a | string match --quiet --ignore-case --regex microsoft
        # WSL / Windows
        __done_run_powershell_script '
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WindowsCompat {
  [DllImport("user32.dll")]
  public static extern IntPtr GetForegroundWindow();
}
"@
[WindowsCompat]::GetForegroundWindow()
'

    else if test "$__done_allow_nongraphical" -eq 1
        echo nongraphical
    end
end

# =============================================================================
# Check: Is the command window still focused?
# =============================================================================
function __done_is_process_window_focused
    if test "$__done_allow_nongraphical" -eq 1
        return 1
    end

    set -l current_window (__done_get_focused_window_id)

    # Can't detect window — skip notification safely
    if test -z "$current_window"
        return 0
    end

    if test "$__done_initial_window_id" != "$current_window"
        return 1   # unfocused → notify
    end

    # tmux: verify pane is active
    if type -q tmux; and test -n "$TMUX"
        tmux list-panes -a -F "#{session_attached} #{window_active} #{pane_pid}" \
            | string match -q "1 1 $fish_pid"
        return $status
    end

    # GNU screen: verify attached
    if type -q screen; and test -n "$STY"
        string match --quiet --regex "$STY\s+\(Attached" (screen -ls)
        return $status
    end

    return 0   # focused → no notification
end

# =============================================================================
# Duration Formatter  (ms → "1h 2m 3s")
# =============================================================================
function __done_humanize_duration -a milliseconds
    set -l seconds (math --scale=0 "$milliseconds / 1000 % 60")
    set -l minutes (math --scale=0 "$milliseconds / 60000 % 60")
    set -l hours   (math --scale=0 "$milliseconds / 3600000")

    set -l parts
    test $hours   -gt 0 && set -a parts "$hours h"
    test $minutes -gt 0 && set -a parts "$minutes m"
    test $seconds -gt 0 && set -a parts "$seconds s"

    echo (string join " " $parts)
end

# =============================================================================
# Notification Dispatcher
# Auto-selects backend: notify-send → terminal-notifier → WSL → echo
# =============================================================================
function __done_send_notification -a title -a message
    if uname -a | string match --quiet --ignore-case --regex microsoft
        __done_windows_notification $title $message

    else if type -q notify-send
        # Linux — libnotify (needs mako/dunst/swaync running)
        set -l sound_args
        if test "$__done_notify_sound" -eq 1
            set sound_args --hint string:sound-name:complete
        end

        notify-send \
            --urgency=normal \
            --icon=utilities-terminal \
            --app-name=fish \
            --expire-time=$__done_notification_duration \
            $sound_args \
            "$title" "$message"

    else if type -q terminal-notifier
        # macOS fallback
        terminal-notifier -title "$title" -message "$message"

    else
        # Last resort — print inline
        echo "[$title] $message"
    end
end

# =============================================================================
# Event: Capture window before command runs
# =============================================================================
function __done_started --on-event fish_preexec
    set -g __done_initial_window_id (__done_get_focused_window_id)
end

# =============================================================================
# Event: Notify after command finishes
# =============================================================================
function __done_ended --on-event fish_postexec
    set -l cmd      $argv[1]
    set -l duration $CMD_DURATION

    test "$__done_enabled" -eq 0;              and return
    test $duration -le $__done_min_cmd_duration; and return

    if string match --quiet --regex -- "$__done_exclude" "$cmd"
        return
    end

    if __done_is_process_window_focused
        return
    end

    set -l humanized (__done_humanize_duration $duration)
    set -l title     "Done in $humanized"
    set -l message   (prompt_pwd)" · $cmd"

    __done_send_notification "$title" "$message"
end
