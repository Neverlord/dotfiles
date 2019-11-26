# -- include all scripts in $HOME/.bash ---------------------------------------

if [ -d "$HOME/.bash" ]; then
  for i in "$HOME/.bash/"*; do
    source "$i"
  done
fi

# -- set default settings for languages, colors, etc. -------------------------

# Make sure our language is US english with UTF-8 encoding.
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# Make `ls` output colored.
export CLICOLOR=1
export LSCOLORS="DxGxcxdxCxegedabagacad"

# Increase size of bash history.
export HISTFILESIZE=50000000

# -- path setup ---------------------------------------------------------------

# Tell BibteX where to find the bibliography databases.
export BIBINPUTS="$HOME/papers/bib"

# Settings specific to macOS.
if [ "$(uname)" == "Darwin" ] ; then
  # Tell CMake where to find our OpenSSL
  export OPENSSL_ROOT_DIR=$(brew --prefix openssl)
  # Configure symlink to the iCloud storage if not present.
  have_icloud_drive=false
  if [ -d "$HOME/iCloudDrive" ]; then
    have_icloud_drive=true
  else
    long_path="$HOME/Library/Mobile Documents/com~apple~CloudDocs/"
    if [ -d "$long_path" ]; then
      if ln -s "$long_path" "$HOME/iCloudDrive"; then
        have_icloud_drive=true
      fi
    fi
  fi
  # Tell `pass` where to find the store.
  if [ "$have_icloud_drive" = true ]; then
    export PASSWORD_STORE_DIR=$HOME/iCloudDrive/.password-store
  fi
fi

# -- custom commands and aliases ----------------------------------------------

# Tries to find a workspace directory containing a `.ctrlp` stopper file.
# Otherwise returns `PWD`.
function workspace_root() {
  if [ -f ".ctrlp" ]; then
    echo "$PWD"
    return 0
  fi
  if [ -d "$PWD/workspace" ]; then
    echo "$PWD/workspace"
    return 0
  fi
  local path="$(dirname $PWD)"
  while [ "$path" != '/' ]; do
    if [ -f "$path/.ctrlp" ]; then
      echo "$path"
      return 0
    fi
    path="$(dirname $path)"
  done
  echo "$PWD"
}

# Convenience alias for opening the workspace.
alias "ws=(cd \$(workspace_root) && mvim)"

# Convenience alias for piping log-formatted output to Vim.
alias lvim="vim -c 'set syntax=log' -"

# -- Include Git status in bash prompt ----------------------------------------

# Generates a nice Git prompt for the current branch.
function _git_prompt() {
  local git_status="`git status -unormal 2>&1`"
  if ! [[ "$git_status" =~ not\ a\ git\ repo ]]; then
    if [[ "$git_status" =~ nothing\ to\ commit ]]; then
      local ansi=32
    elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
      local ansi=35
    else
      local ansi=31
    fi
    if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
      branch=${BASH_REMATCH[1]}
      #test "$branch" != master || branch='master'
    else
      # Detached HEAD.  (branch=HEAD is a faster alternative.)
      branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null ||
          echo HEAD`)"
    fi
    echo -n ' \[\e[1;34m\]# \[\e[1;'"$ansi"'m\]'"$branch"
  fi
}

# Customize command prompt.
function _prompt_command() {
  PS1='@\h\[\e[m\]: \[\e[1;34m\]\w\[\e[m\]'"`_git_prompt`"'\[\e[1;34m\] \$\[\e[m\] '
}

PROMPT_COMMAND=_prompt_command
