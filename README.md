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
brew install bash vim cquery ninja clang-format hub stdman openssl gpg pass

# GUI tools.
brew cask install vimr

# LaTeX and UseLATEX environment
brew install poppler imagemagick
```

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

