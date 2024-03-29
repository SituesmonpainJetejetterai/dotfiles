#!/bin/sh

# Updating the system and installing some applications.

printf "\n%s\n\n" "Updating the system and installing applications"
sudo apt update -y && sudo apt-get full-upgrade -y
printf "\n"
sudo apt install tmux vim tree htop git shellcheck pylint python3 less curl ed -y
printf "\n"

# variable
setup_path="$(dirname "$(readlink -f "$0")")"

# vim setup

printf "\n%s\n" "symlinking vim config in ~/.vim"
ln -sf "${setup_path}/vim/.vim" "$HOME"

# tmux setup

printf "\n%s\n" "symlinking the tmux configuration file"
ln -sf "${setup_path}/tmux/.tmux.conf" "$HOME"

# git setup

printf "\n%s\n" "symlinking the global git config file"
ln -sf "${setup_path}/git/.gitconfig" "$HOME"

# bash setup

printf "\n%s\n" "symlinking the scripts for bash configuration"
ln -sf "${setup_path}/sh/bin" "$HOME"

printf "\n%s\n" "adding lines to ~/.bashrc to source the scripts"

# Escaping the character ${f} with \ helps to keep its literal value, i.e. outputs it as the string: "${f}"
# Prevent duplicate entries in the $PATH variable with this logic
# Source: https://stackoverflow.com/a/15506990

string=$(cat <<EOT
# ---
## Source everything
for f in $HOME/bin/.bash/.*
do
    if [ ! -d "\${f}" ]; then source "\${f}"; fi
done
BIN="$HOME/bin"
if printf "%s" "\${PATH}" | grep -q "\${BIN}"
then
    return 0
else
    export PATH=\${PATH}:\${BIN}
fi
EOT
)

grep -qx "Source everything" "$HOME/.bashrc" || printf "%s" "${string}" >> "$HOME/.bashrc"
printf "\n%s%s\n" "This is the current path: " "$PATH"
