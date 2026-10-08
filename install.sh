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
    # Download first so a failed curl aborts the script
    brew_installer=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
    /bin/bash -c "$brew_installer"
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
if ! HOMEBREW_BUNDLE_NO_JOBS=1 brew bundle --file="$DOTFILES_DIR/Brewfile"; then
    echo "⚠️  Some Brewfile entries failed. Continuing with the rest of the setup."
    echo "   Re-run: brew bundle --file=\"$DOTFILES_DIR/Brewfile\""
fi

# --- Stow ---
# Before Oh My Zsh, so its installer keeps our ~/.zshrc instead of writing its own
echo ""
echo "🔗 Symlinking dotfiles with stow..."
cd "$DOTFILES_DIR"
stow .
echo "✅ Dotfiles symlinked successfully."

# --- Oh My Zsh ---
echo ""
echo "💻 Installing Oh My Zsh..."
if [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    echo "✅ Oh My Zsh already installed, skipping."
else
    omz_installer=$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$omz_installer"
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

# --- Agent Skills ---
echo ""
echo "🧠 Linking agent skills into Claude Code..."
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
mkdir -p "$CLAUDE_DIR/skills"
ln -sfn "$HOME/.agents/AGENTS.md" "$CLAUDE_DIR/CLAUDE.md"
for skill in "$HOME/.agents/skills"/*/; do
    [ -d "$skill" ] || continue
    name=$(basename "$skill")
    dest="$CLAUDE_DIR/skills/$name"
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "⚠️  Skipping $name: $dest exists and is not a symlink."
        continue
    fi
    ln -sfn "$HOME/.agents/skills/$name" "$dest"
done
echo "✅ Agent skills linked."

echo ""
echo "================================================================="
echo "  🥳 Done! Restart your terminal to apply changes."
echo "  📝 Create a .zshrc.local file to export secrets."
echo "  🚀 Import Raycast config: Raycast → Import Settings & Data."
echo "================================================================="
