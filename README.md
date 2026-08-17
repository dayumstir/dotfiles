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

Then create a `.zshrc.local` file to export secrets, import the Raycast config
(Raycast → Import Settings & Data), and enjoy! 🎉

## 🧑‍💻 Development

### Update Brewfile

```sh
brew bundle dump --force
```

### Update Oh My Zsh and custom plugins/themes

```sh
upgrade_oh_my_zsh_all
```

An alias from the `autoupdate` plugin. It runs Oh My Zsh's `tools/upgrade.sh`,
then `upgrade_oh_my_zsh_custom` to update every custom plugin and theme in
`omz-custom/`. Note that running `omz update` directly will not update the
custom plugins.

### Update the Raycast config

Export from Raycast → Export Settings & Data, drop the new `.rayconfig` at the
repo root, and delete the previous one.
