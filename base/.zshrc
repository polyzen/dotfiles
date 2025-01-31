autoload -Uz colors disambiguate-keeplast
colors

setopt appendhistory \
  correct \
  histexpiredupsfirst \
  histignorespace \
  histreduceblanks \
  interactivecomments \
  nobgnice \
  nolistbeep \
  printexitvalue \
  promptsubst

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -v
KEYTIMEOUT=1

path+=~/.local/bin
fpath+=~/.local/fpath
precmd() { disambiguate-keeplast }
PROMPT='$REPLY %(!.#.>) '
RPROMPT='$(gitprompt-rs zsh)'

export DIFFPROG='nvim -d'
export EDITOR=nvim
export LS_COLORS="$(vivid generate jellybeans)"
export MANPAGER='nvim +Man!'

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
gpg-connect-agent updatestartuptty /bye >/dev/null

alias cp='cp --reflink=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto --file-type'

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

zstyle ':completion:*' completer _complete _complete:-fuzzy _correct _approximate _ignored
zstyle ':completion:*' list-rows-first no
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

() {
   local -a prefix=( '\e'{\[,O} )
   local -a up=( ${^prefix}A ) down=( ${^prefix}B )
   local key=
   for key in $up[@]; do
      bindkey "$key" up-line-or-history
   done
   for key in $down[@]; do
      bindkey "$key" down-line-or-history
   done
}

bindkey '^I' menu-select
bindkey $terminfo[kcbt] reverse-menu-select
bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect $terminfo[kcbt] reverse-menu-complete
