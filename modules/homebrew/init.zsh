#
# Defines Homebrew aliases.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Return if requirements are not found.
if [[ "$OSTYPE" != (darwin|linux)* ]]; then
  return 1
fi

#
# Variables
#

# Load standard Homebrew shellenv into the shell session.
# Load 'HOMEBREW_' prefixed variables only. Avoid loading 'PATH' related
# variables as they are already handled in standard zsh configuration.
if (( $+commands[brew] )); then
  eval "${(@M)${(f)"$(brew shellenv 2> /dev/null)"}:#export HOMEBREW*}"
fi

#
# Aliases
#

# Homebrew
alias brewc='brew cleanup'
alias brewi='brew install'
alias brewL='brew leaves'
alias brewl='brew list'
alias brewh='brew help'
alias brewo='brew outdated'
alias brews='brew search'
alias brewu='brew upgrade'
alias brewx='brew uninstall'

# Homebrew Cask
alias cask='brew cask'
alias caskc='hb_deprecated brew cask cleanup'
alias caskC='hb_deprecated brew cask cleanup'
alias caski='brew cask install'
alias caskh='brew cask help'
alias caskl='brew cask list'
alias casko='brew cask outdated'
alias casks='hb_deprecated brew cask search'
alias caskx='brew cask uninstall'

function hb_deprecated {
  local cmd="${@[3]}"
  local cmd_args="${@:4}"

  printf "'brew cask %s' has been deprecated, " "${cmd}"
  printf "using 'brew %s' instead\n" "${cmd}"

  command brew "${cmd}" "${=cmd_args}"
}

if [ $commands[fzf] ]; then
  function brew_install {
    if [ -z $@ ]; then
      fzf_search_install
    else
      command brew install $@
    fi
  }

  function brew_search {
    if [ -z $@ ]; then
      fzf_search_install
    else
      command brew search $@
    fi
  }

  function fzf_search_install {
      local inst=$(brew search | fzf -m)

      if [[ $inst ]]; then
        for prog in $(echo $inst);
        do; brew install $prog; done;
      fi
  }

  alias brewi='brew_install'
  alias brews='brew_search'
fi

