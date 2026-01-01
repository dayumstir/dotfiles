#!/bin/bash

echo "--------------------------------------------------"
echo "🍺 Starting Homebrew installation..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "✅ Homebrew installed!"
echo "--------------------------------------------------"

echo "📁 Cloning dotfiles repository..."
git clone --recurse-submodules https://github.com/dayumstir/dotfiles.git ~/dotfiles
echo "✅ Repository cloned!"
echo "--------------------------------------------------"

cd ~/dotfiles

echo "📦 Running brew bundle..."
brew bundle
echo "✅ Brew bundle done!"
echo "--------------------------------------------------"

echo "🔗 Running stow to symlink dotfiles..."
stow .
echo "✅ Symlinking done!"
echo "--------------------------------------------------"
