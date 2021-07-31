#!/bin/bash

echo "Dotfiles provided for given environments:"
echo -e "*****************************************"
echo "	1) Arch"
echo -e "*****************************************\n"

read -p "Select your environment: " ENV_INDEX
case $ENV_INDEX in
  1)
    cd files/arch
    ./install.sh
    cd ../..
    ;;
  *)
    echo "No environment selected!"
    ;;
esac
echo "Bye"

echo -e "\n\nnvim may require additional set up:"
echo " 1) Installation of vim-plug"
echo "    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \\"
echo "    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'"
echo " 1) Plugin installation"
echo "    Open nvim and enter the command :PlugInstall"
