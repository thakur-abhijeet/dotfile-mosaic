# ╔══════════════════════════════════════════╗
# ║             SSH Agent Setup              ║
# ║             Abhijeet · Dotfiles          ║
# ╚══════════════════════════════════════════╝

set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket

if not pgrep -u (whoami) ssh-agent >/dev/null
    eval (ssh-agent -c)
end

# Check if keys are loaded, if not add default key quietly
if test -f ~/.ssh/id_ed25519
    ssh-add -l >/dev/null 2>&1; or ssh-add ~/.ssh/id_ed25519 >/dev/null 2>&1
end
