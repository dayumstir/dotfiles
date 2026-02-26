#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"

echo "=================================================="
echo "  🚀 Dotfiles Setup"
echo "=================================================="

# --- Homebrew ---
echo ""
echo "🍺 Installing Homebrew..."
if command -v brew &>/dev/null; then
    echo "✅ Homebrew already installed, skipping."
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is on PATH for the rest of this script (Apple Silicon + Intel)
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"

# --- Dotfiles ---
echo ""
echo "📁 Cloning dotfiles repository..."
if [ -d "$DOTFILES_DIR" ]; then
    echo "✅ Dotfiles directory already exists, updating submodules..."
    git -C "$DOTFILES_DIR" submodule update --init --recursive
else
    git clone --recurse-submodules https://github.com/dayumstir/dotfiles.git "$DOTFILES_DIR"
fi

# --- Brew Bundle ---
echo ""
echo "📦 Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# --- Oh My Zsh ---
echo ""
echo "💻 Installing Oh My Zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✅ Oh My Zsh already installed, skipping."
else
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- Stow ---
echo ""
echo "🔗 Symlinking dotfiles with stow..."
cd "$DOTFILES_DIR"
stow .

echo ""
echo "=================================================="
echo "  ✅ Done! Restart your terminal to apply changes."
echo "=================================================="
