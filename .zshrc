## zshrc
# If not running tmux, run tmux
if [[ $+commands[tmux] != 0 && "$TMUX" == "" ]]; then
  TERM=xterm-256color tmux -2
else
  # tmux gets rid of environment variables like path. That was fun trying to figure out.
  if [[ "$ZDOTDIR" == "" ]]; then
    source $HOME/.zshenv
  else
    source $ZDOTDIR/.zshenv
  fi
fi

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

if [[ $+commands[terminator] != 0 ]]; then
  autoload vimterm;
fi
