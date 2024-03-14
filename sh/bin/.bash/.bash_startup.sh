#!/bin/sh

# Set the terminal to show colours
export TERM=xterm-256color

# Clear the screen when executing the bash shell. Useful when I'm sourcing the .bashrc
clear

# Start TMUX if not in it already
if [ -z "$TMUX" ]; then
    if tmux has-session 2>/dev/null; then
        # Attach to session
        tmux a
    else
        tmux new
    fi
fi

# Showing system information
printf "%s%s\n" "PUBLIC IP: " "$(curl -sS ifconfig.me)"
printf "%s%s\n" "PRIVATE IP: " "$(hostname -I | awk '{print $1}')"
printf "%s%s\n" "USER: " "${USER}"
printf "%s%s\n" "TIME: " "$(date '+%a %d %b %T %Y %Z')"
printf "%s%s\n" "UPTIME: " "$(uptime -p)"
printf "%s%s\n" "CPU: " "$(lscpu | grep "Model\sname" | sed "s/.*:\s*//")"
printf "%s%s\n" "CPU USAGE: " "$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')"
printf "%s%s\n" "KERNEL: " "$(uname -rms)"
printf "%s%s\n" "PACKAGES: " "$(dpkg --get-selections | wc -l)"
printf "%s%s\n" "MEMORY: " "$(free -m -h | awk '/Mem/{print $3"/"$2}')"
printf "%s%s%s\n" "\$PATH contains " "\$HOME/bin: " "$(if $(printf "%s" "$PATH" | grep -q "$HOME/bin"); then printf "%s" "Yes"; else printf "%s" "No"; fi)"


# Set Tabs
tabs -p

# Set vim keys for bash
set -o vi
