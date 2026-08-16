# ╔══════════════════════════════════════════╗
# ║                 Aliases                  ║
# ║             Abhijeet · Dotfiles          ║
# ╚══════════════════════════════════════════╝

alias clr 'clear && cd && neofetch'

# ── Listing ───────────────────────────────────
alias ls  'eza -al --color=always --group-directories-first --icons'
alias la  'eza -a  --color=always --group-directories-first --icons'
alias ll  'eza -l  --color=always --group-directories-first --icons'
alias lt  'eza -aT --color=always --group-directories-first --icons'
alias l.  "eza -a | grep -e '^\\.'"

# ── Navigation ────────────────────────────────
alias ..    'cd ..'
alias ...   'cd ../..'
alias ....  'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../../'

# ── Color overrides ───────────────────────────
alias dir   'dir --color=auto'
alias vdir  'vdir --color=auto'
alias grep  'grep --color=auto'
alias fgrep 'fgrep --color=auto'
alias egrep 'egrep --color=auto'

# ── App overrides ─────────────────────────────
alias vi   'nvim'
alias wget 'wget -c'
alias lr   'ranger'
alias ly   'yazi'
alias please 'sudo'

# bat as cat — only if installed
if type -q bat
    alias cat 'bat --style=plain'
end

# ── Network ───────────────────────────────────
alias myip 'curl -s ifconfig.me'
alias ports 'ss -tulnp'
alias tb    'nc termbin.com 9999'

# ── Archives ──────────────────────────────────
alias tarnow 'tar -acf'
alias untar  'tar -zxvf'

# ── Process / Hardware ────────────────────────
alias psmem   'ps auxf | sort -nr -k 4'
alias psmem10 'ps auxf | sort -nr -k 4 | head -10'
alias hw      'hwinfo --short'
alias jctl    'journalctl -p 3 -xb'

# ── System — Package Management (Universal) ────
alias install 'pkg install'
alias remove  'pkg remove'
alias search  'pkg search'
alias update  'pkg update'
alias clean   'pkg clean'

# Additional helper aliases for Arch/CachyOS (optional)
if type -q pacman
    alias cleanup   'sudo pacman -Rns (pacman -Qtdq)'
    alias fixpacman 'sudo rm /var/lib/pacman/db.lck'
    alias grubup    'sudo grub-mkconfig -o /boot/grub/grub.cfg'
    alias gitpkg    'pacman -Q | grep -i "\-git" | wc -l'
    alias rip       "expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
    if type -q cachyos-rate-mirrors
        alias mirror 'sudo cachyos-rate-mirrors'
    end
end

# ── Git ───────────────────────────────────────
alias gi  'git init'
alias ga  'git add'
alias gaa 'git add --all'
alias gc  'git commit'
alias gcm 'git commit -m'
alias gp  'git push'
alias gpl 'git pull'
alias gl  'git log --oneline --graph --decorate'
alias gs  'git status'
alias gd  'git diff'
alias gb  'git branch'
alias gco 'git checkout'
alias gst 'git stash'
alias grb 'git rebase'

# ── Spring Boot / Maven ───────────────────────
alias mvnc 'mvn clean'
alias mvnp 'mvn clean package'
alias mvnr 'mvn spring-boot:run'
alias mvnt 'mvn test'
alias mvns 'mvn clean package -DskipTests'
