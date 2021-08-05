#/bin/bash

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
