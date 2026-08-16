# ╔══════════════════════════════════════════╗
# ║                Functions                 ║
# ║             Abhijeet · Dotfiles          ║
# ╚══════════════════════════════════════════╝

# Show command history with timestamps
function history
    builtin history --show-time='%F %T '
end

# Backup a file to <filename>.bak
function backup --argument filename
    cp $filename $filename.bak
end

# Smart copy: recursive if source is a directory
function copy
    set count (count $argv | tr -d \n)

    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

# Banner / System welcome
function banner
    set_color green
    echo " SYSTEM READY. WELCOME BACK, ABHIJEET."
    set_color white
    echo " -----------------------------------------------------------------------"
    uptime -p
    date +" %Y-%m-%d %H:%M:%S"
    set_color normal
end

# System report
function sysinfo
    set_color yellow
    echo "[ SYSTEM REPORT ]"
    set_color brblack
    echo "-----------------"
    set_color normal
    echo " HOST:    "(hostname)
    echo " KERNEL:  "(uname -r)
    echo " UPTIME:  "(uptime -p)
    echo " MEMORY:  "(free -h | awk '/^Mem:/ {print $3 "/" $2}')
    echo " DISK:    "(df -h / | awk '/\// {print $3 "/" $2 " (" $5 ")"}')
    set_color brblack
    echo "-----------------"
    set_color normal
end

# Simple CLI Todo list
function todo
    set -l TODO_FILE "$HOME/.todo_list"
    switch "$argv[1]"
        case add
            echo "[ ] "(string join " " $argv[2..-1]) >> "$TODO_FILE"
        case ls
            cat -n "$TODO_FILE"
        case rm
            sed -i "$argv[2]d" "$TODO_FILE"
        case done
            sed -i "$argv[2]s/\[ \]/\[x\]/" "$TODO_FILE"
        case '*'
            echo "Usage: todo [add|ls|rm|done] [task/index]"
    end
end

# Weather report helper
function weather
    set -l loc "Kathmandu"
    if test -n "$argv[1]"
        set loc "$argv[1]"
    end
    curl -s "v2.wttr.in/$loc?m1" | head -n 30
end

# Clear and show banner
function cls
    clear
    banner
end

# Cmatrix shortcut
function matrix
    if type -q cmatrix
        cmatrix
    else
        echo "Error: cmatrix not installed."
    end
end

# Clock display using figlet
function clock
    watch -t -n 1 "date +%T | figlet -f slant || date +%T"
end
