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

Create a `.zshrc.local` file to export secrets, import the Raycast config, and enjoy! 🎉

## 🧑‍💻 Development

### Update Brewfile

```sh
brew bundle dump --force
```

### Adding new custom omz plugins/themes

```sh
git submodule add <URL_TO_REPO> omz-custom/<PLUGINS/THEMES>/<CUSTOM_PLUGIN/THEME>
```

Custom plugins/themes are also git repositories which will be nested in this dotfiles repository.
