#!/bin/bash
if [ -e "${HOME}/.ssh/authorized_keys" ]; then
  echo "Updating Authorized Keys..."
  for key in `cat .ssh/authorized_keys | cut -d' ' -f3`; do if grep -qE "$key\$" "${HOME}/.ssh/authorized_keys"; then echo "  Updating existing ssh key $key"; sed -i "/$key\$/d" "${HOME}/.ssh/authorized_keys"; fi; done
  cat .ssh/authorized_keys >> ~/.ssh/authorized_keys
else
  echo "Installing Authorized Keys"
  if [ ! -d "${HOME}/.ssh" ]; then
    mkdir ~/.ssh && chmod 0700 ~/.ssh
  fi
  cp $(dirname $(realpath $0))/.ssh/authorized_keys ~/.ssh/ && chmod 0600 ~/.ssh/authorized_keys
fi

echo "Installing .bashrc"
if [ -e "${HOME}/.bashrc" ]; then
  cp -L ~/.bashrc ~/.bashrc_old.`date +%s`
fi
ln -fs $(dirname $(realpath $0))/.bashrc ../

echo "Installing .gitconfig"
if [ -e "${HOME}/.gitconfig" ]; then
  cp -L ~/.gitconfig ~/.gitconfig_old.`date +%s`
fi
ln -fs $(dirname $(realpath $0))/.gitconfig ~/

echo "Installing .vimrc"
if [ -e "${HOME}/.vimrc" ]; then
  cp -L ~/.vimrc ~/.vimrc_old.`date +%s`
fi
ln -fs $(dirname $(realpath $0))/.vimrc ~/

echo "Installing .tmux stuff"
if [ -e "${HOME}/.tmux.conf" ]; then
  cp -L ~/.tmux.conf ~/.tmux_old.`date +%s`
fi
ln -fs $(dirname $(realpath $0))/.tmux.conf ~/
if [ -e "${HOME}/.tmux.conf.local" ]; then
  cp -L ~/.tmux.conf.local ~/.tmux_local_old.`date +%s`
fi
ln -fs $(dirname $(realpath $0))/.tmux.conf.local ~/

echo "Installing .vim_runtime"
if [ -e "${HOME}/.vim_runtime" ] && [ ! -L "${HOME}/.vim_runtime" ]; then
  mv ~/.vim_runtime ~/.vim_runtime_old.`date +%s`
fi
ln -fs $(dirname $(realpath $0))/.vim_runtime ~/

echo "Installing sudoer profile"
sudo install -m 0644 $(dirname $(realpath $0))/.sudoer_profile /etc/sudoers.d/99-nick-nopasswd

echo "Done!"
