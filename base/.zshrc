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
bindkey $terminfo[kcbt] reverse-menu-complete
KEYTIMEOUT=1

path+=~/.local/bin
fpath+=~/.local/fpath
precmd() { disambiguate-keeplast }
PROMPT='$REPLY %(!.#.>) '
RPROMPT='$(gitprompt-rs zsh)'

export EDITOR=nvim
export LS_COLORS="$(vivid generate jellybeans)"
export MANPAGER='nvim +Man!'

alias cp='cp --reflink=auto'
alias exa='exa -F'
alias grep='grep --color=auto'
alias ls='ls --color=auto --file-type'

zstyle ':autocomplete:*' fzf-completion yes
zstyle ':autocomplete:*' widget-style menu-select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
