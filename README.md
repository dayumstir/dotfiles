# Dotfiles Setup

This repository contains my personal configuration files (dotfiles). Follow the steps below to set up the environment on a new machine.

## Prerequisites

- **Git**: Required to clone the repository.
- **Homebrew**: Required to install dependencies and manage packages.

## Installation Guide

### 1. Clone the Repository

First, install Git if it is not already available, and clone this repository to your home directory (or your preferred location):

```sh
git clone <repository-url> ~/dotfiles
cd ~/dotfiles
```

### 2. Install Dependencies

Install Homebrew if you haven't already:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then, use the `Brewfile` to install all required packages, applications, and tools (including `stow`):

```sh
brew bundle
```

### 3. Symlink Dotfiles

Once `stow` is installed via Homebrew, use it to symlink the dotfiles to your home directory:

```sh
stow .
```

This command will create symbolic links for the configuration files in the current directory (e.g., `.zshrc`, `.vimrc`) pointing to your home directory.
