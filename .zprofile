path+=~/.local/bin
export EDITOR=vim
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

eval $(dircolors ~/.config/dir_colors)
