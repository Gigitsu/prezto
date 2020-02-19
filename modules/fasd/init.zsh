#
# Maintains a frequently used file and directory list for fast access.
#
# Authors:
#   Wei Dai <x@wei23.net>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Load dependencies.
pmodload 'editor'

if [ $commands[fasd] ]; then # check if fasd is installed
  #
  # Initialization
  #

  fasd_cache="${TMPDIR:-/tmp}/prezto-fasd-cache.$UID.zsh"
  if [[ "${commands[fasd]}" -nt "$cache_file" \
        || "${ZDOTDIR:-$HOME}/.zpreztorc" -nt "$cache_file" \
        || ! -s "$cache_file"  ]]; then
    fasd --init auto >| "$fasd_cache"
  fi

  if [ $commands[fzf] ]; then
    jj() {
      local dir
      dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
    }
  else
    alias jj='zz'
  fi

  source "$fasd_cache"
  unset fasd_cache

  alias v='f -e "$EDITOR"'
  alias o='a -e xdg-open'
  alias j='z'
fi

