# dotfiles

This repository contains my personal configuration files (dotfiles).

## 💪 Features

- Entirely bootstrapped
- No dependencies or prerequisites
- Single script to setup new machines

## 🔧 Setup

Run this one-liner to install everything:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/dayumstir/dotfiles/main/install.sh)"
```

Create a `.zshrc.local` file to export secrets, import the Raycast config (under `Import Settings & Data`), and enjoy! 🎉

## 🧑‍💻 Development

### Update Brewfile

```sh
brew bundle dump --force
```

### Updating Oh My Zsh and custom plugins/themes

```sh
upgrade_oh_my_zsh_all
```

This calls the Oh My Zsh update function `omz update`, then runs `upgrade_oh_my_zsh_custom` to update all custom plugins and themes.
