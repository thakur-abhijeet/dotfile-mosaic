# ╔══════════════════════════════════════════╗
# ║          Fish Shell — config.fish        ║
# ║             Abhijeet · Dotfiles          ║
# ╚══════════════════════════════════════════╝
#
# Structure:
#   config.fish               ← bootstrap + env (you are here)
#   conf.d/aliases.fish       ← all aliases
#   conf.d/functions.fish     ← custom functions
#   conf.d/keybinds.fish      ← !! / !$ history expansion
#   conf.d/ssh-agent.fish     ← SSH Agent configuration
#   conf.d/done.fish          ← auto-loaded (notification plugin)

# =============================================================================
# XDG Base Directories  (set first — everything below depends on these)
# =============================================================================
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME  "$HOME/.cache"
set -gx XDG_DATA_HOME   "$HOME/.local/share"
set -gx XDG_STATE_HOME  "$HOME/.local/state"

# =============================================================================
# PATH Management
# =============================================================================
fish_add_path -p \
    ~/.local/bin \
    /usr/local/bin \
    $HOME/.cargo/bin \
    ~/Applications/depot_tools

# =============================================================================
# Default Applications & Environment
# =============================================================================
set -gx EDITOR   nvim
set -gx VISUAL   nvim
set -gx BROWSER  zen-browser
set -gx PAGER    less
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx LESS         "-R --use-color"
set -gx LESSHISTFILE "$XDG_STATE_HOME/less_history"
set -gx BAT_THEME    "tokyonight_night"
set -gx LANG   en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# =============================================================================
# Wayland Environment
# =============================================================================
if test -n "$WAYLAND_DISPLAY"
    set -gx GDK_BACKEND        wayland
    set -gx QT_QPA_PLATFORM    wayland
    set -gx MOZ_ENABLE_WAYLAND 1
    set -gx _JAVA_AWT_WM_NONREPARENTING 1
end

# X fallback for XWayland apps
set -gx DISPLAY ":0"

# =============================================================================
# Java Home Detection
# =============================================================================
function __java_home_from_alternatives
    if test -L /etc/alternatives/java
        set -l resolved (readlink -f /etc/alternatives/java)
        echo (string replace -r '/bin/java$' '' $resolved)
    end
end

if not set -q JAVA_HOME
    set -l detected (__java_home_from_alternatives)
    if test -n "$detected"
        set -gx JAVA_HOME $detected
    else if test -d /usr/lib/jvm/java-17-openjdk
        set -gx JAVA_HOME /usr/lib/jvm/java-17-openjdk
    end
end

if set -q JAVA_HOME
    fish_add_path $JAVA_HOME/bin
end

# =============================================================================
# History Configuration
# =============================================================================
set -gx HISTSIZE 50000
set -gx SAVEHIST 50000
set -gx HISTFILE "$XDG_STATE_HOME/history"

# =============================================================================
# Theme Configuration
# =============================================================================
# Load active theme colors from ~/.config/fish/themes/theme if it exists
if test -f ~/.config/fish/themes/theme
    while read -l line
        if not string match -q -r '^\s*#' -- "$line"; and test -n (string trim -- "$line")
            set -l parts (string split -m 1 ' ' -- "$line")
            if test (count $parts) -eq 2
                set -g $parts[1] $parts[2]
            end
        end
    end < ~/.config/fish/themes/theme
end

# =============================================================================
# Greeting Banner
# =============================================================================
function fish_greeting
    if status is-interactive
        banner
    end
end

# =============================================================================
# Interactive-only Init
# =============================================================================
if status is-interactive

    # Prompt
    if type -q starship
        starship init fish | source
    end

    # Smart cd
    if type -q zoxide
        zoxide init fish | source
    end

    # Autojump fallback
    if type -q autojump
        source (autojump init fish | psub)
    end

    # FZF (requires fzf >= 0.48.0)
    if type -q fzf
        if fzf --fish &>/dev/null
            fzf --fish | source
        end
    end

end
