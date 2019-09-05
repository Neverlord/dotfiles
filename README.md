# About

This repository contains my personal dotfiles for customizing VIM and Bash.
Feel free to copy stuff you like.

# Setup a New Home Directory (Overrides Local Files!)

```
git init . && git remote add origin https://github.com/Neverlord/dotfiles.git && git fetch && git checkout -f master
```

# Software Setup (macOS)

```
# Libs and CLI tools.
brew install bash cquery ninja clang-format hub stdman openssl gpg pass

# GUI tools.
brew cask install vimr

# LaTeX and UseLATEX environment
brew install poppler imagemagick

# Neovim bindings for Python
pip install pynvim
pip3 install pynvim
```

Go to `System Preferences` > `Users & Groups` > `Advanced Options` and change
login shell to `/usr/local/bin/bash` (*after* `brew install bash`). This step
is necessary to get proper autocompletion in `bash` working with `pass`.

# Git Setup

```
git config --global core.editor vim
git config --global core.excludesfile ~/.gitignore_global
git config --global user.name "Dominik Charousset"
git config --global user.email ...
```

# Vim and NeoVim Setup

```
vim -c PlugInstall
vimr # type ":PlugInstall"
```

