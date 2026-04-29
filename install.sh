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
    echo "✅ Dotfiles directory already exists, pulling latest..."
    git -C "$DOTFILES_DIR" pull
else
    git clone https://github.com/dayumstir/dotfiles.git "$DOTFILES_DIR"
fi

# --- Brew Bundle ---
echo ""
echo "📦 Installing packages from Brewfile..."
HOMEBREW_BUNDLE_NO_PARALLEL=1 brew bundle --file="$DOTFILES_DIR/Brewfile"

# --- Oh My Zsh ---
echo ""
echo "💻 Installing Oh My Zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✅ Oh My Zsh already installed, skipping."
else
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- Oh My Zsh Custom Plugins & Themes ---
echo ""
echo "🔌 Installing custom plugins and themes..."
CUSTOM_DIR="$DOTFILES_DIR/omz-custom"
plugins=(
    "plugins/autoupdate https://github.com/TamCore/autoupdate-oh-my-zsh-plugins"
    "plugins/you-should-use https://github.com/MichaelAquilina/zsh-you-should-use.git"
    "plugins/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions"
    "plugins/zsh-bat https://github.com/fdellwing/zsh-bat.git"
    "plugins/zsh-completions https://github.com/zsh-users/zsh-completions.git"
    "plugins/zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git"
    "themes/powerlevel10k https://github.com/romkatv/powerlevel10k.git"
)
for entry in "${plugins[@]}"; do
    path="${entry%% *}"
    url="${entry#* }"
    dest="$CUSTOM_DIR/$path"
    if [ -d "$dest" ]; then
        echo "✅ $path already installed, skipping."
    else
        echo "📥 Cloning $path..."
        git clone --depth 1 "$url" "$dest"
    fi
done

# --- Stow ---
echo ""
echo "🔗 Symlinking dotfiles with stow..."
cd "$DOTFILES_DIR"
stow .
echo "✅ Dotfiles symlinked successfully."

echo ""
echo "================================================================="
echo "  🥳 Done! Restart your terminal to apply changes."
echo "  📝 Create a .zshrc.local file to export secrets."
echo "  🚀 Import Raycast config: Raycast → Import Settings & Data."
echo "================================================================="
