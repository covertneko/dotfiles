## zshrc
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' max-errors 2 numeric
zstyle :compinstall filename '/home/eric/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
ZSH=$HOME/.zsh

source $ZSH/opts.zsh
source $ZSH/aliases.zsh
source $ZSH/prompt.zsh

if [[ $+commands[terminator] ]]; then
  autoload vimterm;
fi
