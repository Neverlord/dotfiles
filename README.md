# About

This repository contains my personal dotfiles for customizing VIM and Bash.
Feel free to copy stuff you like.

# Setup a New Home Directory (Overrides Local Files!)

```
git init . && git remote add origin https://github.com/Neverlord/dotfiles.git && git fetch && git checkout -f master
```

# Software Setup (macOS)

```
# Programming environment
brew install vim
brew install ninja
brew install macvim
brew install clang-format

# LaTeX and UseLATEX environment
brew install poppler
brew install imagemagick
```

# Git Setup

```
git config --global core.editor /usr/local/bin/vim
git config --global core.excludesfile ~/.gitignore_global
git config --global user.name "Dominik Charousset"
git config --global user.email ...
```

# VIM Setup

```
vim -c PlugInstall
```

