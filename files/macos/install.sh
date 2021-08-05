#/bin/bash

set -e

echo " * Setting up config files for unprivileged user:"
printf "Setting up .zshrc... "
ln -sf $(pwd)/$(dirname $0)/.zshrc ${HOME}/.zshrc
echo "Done"
printf "Setting up .screenrc... "
ln -sf $(pwd)/$(dirname $0)/.screenrc ${HOME}/.screenrc
echo "Done"
printf "Setting up init.vim... "
mkdir -p ~/.config/nvim
ln -sf $(pwd)/$(dirname $0)/init.vim ${HOME}/.config/nvim/init.vim
echo "Done"
