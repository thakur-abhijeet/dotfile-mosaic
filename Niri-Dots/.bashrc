# .bashrc — Enhanced Bash Configuration
# Ported from Fish configuration for Abhijeet Thakur

# -----------------------------------------------------------------------
# Environment Setup
# -----------------------------------------------------------------------

# PATH Management
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:$PATH"

# Cargo / Rust
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# XDG Base Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Default Applications
export BROWSER="firefox"
export EDITOR="nvim"
export VISUAL="nvim"

# Java (OpenJDK 21) & Wayland Fix
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"
export _JAVA_AWT_WM_NONREPARENTING=1
export GDK_BACKEND=wayland
# export DISPLAY=:0 # Uncomment if needed for specific Xwayland apps

# -----------------------------------------------------------------------
# Shell Options & Behavior
# -----------------------------------------------------------------------

# History Configuration
export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE="$XDG_STATE_HOME/bash_history"
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%F %T "
shopt -s histappend # Append to history file, don't overwrite
shopt -s histverify # Don't execute immediately on history expansion
shopt -s histreedit # Allow editing of failed history substitutions
# Sync history across sessions
PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

# Quality of Life
shopt -s autocd           # cd to a directory by typing its name
shopt -s cdspell          # Correct minor typos in cd
shopt -s checkwinsize     # Update LINES and COLUMNS after each command
shopt -s globstar         # Use ** for recursive globbing
set -o vi                 # Enable Vi-style keybindings (if preferred)

# -----------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------

# --- Listing (eza) ---
if command -v eza >/dev/null; then
    alias ls='eza -al --color=always --group-directories-first --icons'
    alias la='eza -a  --color=always --group-directories-first --icons'
    alias ll='eza -l  --color=always --group-directories-first --icons'
    alias lt='eza -aT --color=always --group-directories-first --icons'
    alias l.="eza -a | grep -i '^\.'"
else
    alias ls='ls --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# --- System ---
alias clr="clear && cd && neofetch"
alias update="sudo pacman -Syu"
alias clean="sudo pacman -Scc"
alias remove="sudo pacman -Rns"
alias search="pacman -Ss"
alias mirror="sudo cachyos-rate-mirrors"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
alias jctl="journalctl -p 3 -xb"

alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias hw='hwinfo --short'
alias big="expac -H M '%m\t%n' | sort -h | nl"
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'
alias tb='nc termbin.com 9999'
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto -n'
alias fgrep='fgrep --color=auto -n'
alias egrep='egrep --color=auto -n'
alias please='sudo'

# --- Apps & Misc ---
alias rr='ranger'
alias ly='yazi'
alias wget='wget -c'

# --- Git ---
alias gi='git init'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gs='git status'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"


# -----------------------------------------------------------------------
# Custom Functions
# -----------------------------------------------------------------------

# Backup a file to <filename>.bak
backup() {
    cp -v "$1" "$1.bak"
}

# Smart copy: recursive if source is a directory
copy() {
    if [ -d "$1" ]; then
        cp -rv "$1" "$2"
    else
        cp -v "$@"
    fi
}

# Create a directory and enter it
mcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# -----------------------------------------------------------------------
# Prompt & Navigation Tools
# -----------------------------------------------------------------------

# Starship (Prompt)
if command -v starship >/dev/null; then
    eval "$(starship init bash)"
fi

# FZF (Fuzzy Finder)
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
fi
if [ -f /usr/share/doc/fzf/examples/completion.bash ]; then
  source /usr/share/doc/fzf/examples/completion.bash
fi

# Zoxide (Smart CD)
if command -v zoxide >/dev/null; then
    eval "$(zoxide init bash)"
fi

# Bash Completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# -----------------------------------------------------------------------
# Startup Aesthetics
# -----------------------------------------------------------------------

# Greeting Banner
if [[ $- == *i* ]]; then
    neofetch
    echo "Welcome back, Abhijeet (Bash Edition)"
fi
