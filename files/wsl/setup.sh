#!/bin/bash
echo "Updating package lists..."
echo $1 | sudo -S apt-get update

echo "Installing ZSH..."
sudo apt-get install -y zsh

echo "Installing Oh-My-Posh..."
sudo apt-get install -y unzip
sudo curl -s https://ohmyposh.dev/install.sh | sudo bash -s

echo "Setting ZSH as default shell..."
sudo chsh -s $(which zsh) $USER

echo 'eval "$(oh-my-posh init zsh --config $HOME/dotfiles-wsl/files/profile-theme.omp.json)"' >> $HOME/.zshrc