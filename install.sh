#!/bin/bash
echo "Updating Authorized Keys..."
if [ -e "${HOME}/.ssh/authorized_keys" ]; then
  for key in `cat .ssh/authorized_keys | cut -d' ' -f3`; do if grep -qE "$key\$" "${HOME}/.ssh/authorized_keys"; then echo "  Updating existing ssh key $key"; sed -i "/$key\$/d" "${HOME}/.ssh/authorized_keys"; fi; done
  cat .ssh/authorized_keys >> ~/.ssh/authorized_keys
fi

echo "Installing .bashrc"
if [ -e "${HOME}/.bashrc" ]; then
  mv ~/.bashrc ~/.bashrc_old.`date +%s`
fi
ln -fs `pwd`/.bashrc ../

echo "Installing .gitconfig"
if [ -e "${HOME}/.gitconfig" ]; then
  mv ~/.gitconfig ~/.gitconfig_old.`date +%s`
fi
ln -fs `pwd`/.gitconfig ~/

echo "Installing .vimrc"
if [ -e "${HOME}/.vimrc" ]; then
  mv ~/.vimrc ~/.vimrc_old.`date +%s`
fi
ln -fs `pwd`/.vimrc ~/

echo "Installing .tmux stuff"
if [ -e "${HOME}/.tmux.conf" ]; then
  mv ~/.tmux.conf ~/.tmux_old.`date +%s`
fi
ln -fs `pwd`/.tmux.conf ~/
if [ -e "${HOME}/.tmux.conf.local" ]; then
  mv ~/.tmux.conf.local ~/.tmux_local_old.`date +%s`
fi
ln -fs `pwd`/.tmux.conf.local ~/

echo "Installing .vim_runtime"
if [ -e "${HOME}/.vim_runtime" ]; then
  mv ~/.vim_runtime ~/.vim_runtime_old.`date +%s`
fi
ln -fs `pwd`/.vim_runtime ~/

echo "Done!"
