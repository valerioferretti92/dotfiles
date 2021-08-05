#!/bin/bash

set -e

echo "Dotfiles provided for given environments:"
echo -e "*****************************************"
echo "	1) Manjaro"
echo "	2) MacOS"
echo -e "*****************************************\n"

read -p "Select your environment: " ENV_INDEX
case $ENV_INDEX in
  1)
    $(dirname $0)/files/manjaro/install.sh
    ;;
  2)
    $(dirname $0)/files/macos/install.sh
    ;;
  *)
    echo "No environment selected, bye!"
    exit -1
    ;;
esac

echo -e "\n\nnvim may require additional set up:"
echo " 1) Installation of vim-plug"
echo "    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \\"
echo "    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'"
echo " 2) Plugin installation"
echo "    Open nvim and enter the command :PlugInstall"
