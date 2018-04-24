# convenience aliases for Git usage
alias "gpl=git pull && git submodule foreach git pull"
alias "gpm=git submodule foreach git checkout master"
alias "gst=git status && git submodule foreach git status"
alias "gph=git push && git submodule foreach git push"

alias lvim="vim -c 'set syntax=log' -"

# convenience alias for building in "build" subdirectory
alias "sn=ninja -C build"

# tell CAF's configure script we're using ninja instead of make
export CMAKE_GENERATOR="Ninja"

# tell BibteX where to find bibliography databases
export BIBINPUTS="$HOME/papers/bib"

# tell CMake where to find our OpenSSL
export OPENSSL_ROOT_DIR=$(brew --prefix openssl)

# make sure our language is US english with UTF-8 encoding
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# colored ls output
export CLICOLOR=1
export LSCOLORS="DxGxcxdxCxegedabagacad"

# longer history
export HISTFILESIZE=50000000

source "$HOME/.bash/git-completion.bash"

# generates a nice Git prompt for the current branch
function _git_prompt() {
  local git_status="`git status -unormal 2>&1`"
  if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
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

# customize command prompt
function _prompt_command() {
  PS1='@\h\[\e[m\]: \[\e[1;34m\]\w\[\e[m\]'"`_git_prompt`"'\[\e[1;34m\] \$\[\e[m\] '
}

PROMPT_COMMAND=_prompt_command

