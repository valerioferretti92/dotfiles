#/bin/bash

set -e

echo " * Setting up config files for unprivileged user:"
printf "Setting up .zshrc... "
printf "REMEMBER to install powerlevel10k and run 'p10k configure'"
printf "Instructions: https://davidtsadler.com/posts/arch/2020-09-07/installing-zsh-and-powerlevel10k-on-arch-linux/"
ln -sf $(pwd)/$(dirname $0)/.zshrc ${HOME}/.zshrc
echo "Done"
printf "Setting up .screenrc... "
ln -sf $(pwd)/$(dirname $0)/.screenrc ${HOME}/.screenrc
echo "Done"
printf "Setting up init.vim... "
mkdir -p ~/.config/nvim
ln -sf $(pwd)/$(dirname $0)/init.vim ${HOME}/.config/nvim/init.vim
echo "Done"

USER_HOME=$HOME
sudo echo " * Setting up config files for root:"
printf "Setting up .zshrc..."
sudo ln -sf $(pwd)/$(dirname $0)/.zshrc-root /root/.zshrc
echo "Done"
printf "Setting up .screenrc... "
sudo ln -sf $(pwd)/$(dirname $0)/.screenrc /root/.screenrc
echo "Done"
printf "Setting up init.vim... "
sudo mkdir -p /root/.config/nvim
sudo ln -sf $(pwd)/$(dirname $0)/init.vim /root/.config/nvim/init.vim
echo "Done"
