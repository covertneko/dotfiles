# zshrc
# Repository info taken from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/ 
# Responsive cwd taken from https://github.com/jondavidjohn/dotfiles
#
#
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' max-errors 2 numeric
zstyle :compinstall filename '/home/eric/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=1000
setopt appendhistory autocd beep extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install

export CLICOLOR=YES
export EDITOR=vim

path+=( "$HOME/.cabal/bin" )
export PATH

alias ls='ls --color=auto'

# Temporarily taken from Steve Losh's fork of oh-my-zsh
function git_prompt_info()
{
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}
parse_git_dirty()
{
  gitstat=$(git status 2>/dev/null | egrep '(^Untracked|^Changes|^Changed but not updated:)')
  if [[ $(echo ${gitstat} | egrep -c "Changes to be committed:") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_DIRTY"
  fi

  if [[ $(echo ${gitstat} | egrep -c "(Untracked files:|Changed but not updated:)") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi 

  if [[ $(echo ${gitstat} | wc -l | tr -d ' ') == 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# Open a terminator window with vim in it
function vimterm()
{
  terminator -b --layout=vimterm -e "vim $@" &> /dev/null & disown
}

# Ugly session loading. Find a plugin later.
function vimcont()
{
  local defaultSession="${HOME}/.vim/sessions/current.vim"
  local session="${HOME}/.vim/sessions/${1}.vim"

  if ! [[ -z $1 ]] && [[ -e $session ]]; then
    echo "Using session \"${session}\"..."
  elif [[ -e $defaultSession ]]; then
    if ! [[ -z $1 ]]; then
      echo "Invalid session name \"${session}\" provided."
    fi
    echo "Using default session \"${defaultSession}\"..."
    session=$defaultSession
  else
    echo "Missing default session. Fix or use vimcont <file>."
    return 1;
  fi

  terminator -b --layout=vimterm -e "vim -S $session" &> /dev/null & disown
}

# Responsive directory length
shrink_cwd()
{
  dir=`pwd`
  in_home=0
  if [[ `pwd` =~ ^"$HOME"(/|$) ]]; then
    dir="~${dir#$HOME}"
    in_home=1
  fi

  workingdir=""
  if [[ `tput cols` -lt 110 ]]; then
    first="/`echo $dir | cut -d / -f 2`"
    letter=${first:0:2}
    if [[ $in_home == 1 ]]; then
      letter="~$letter"
    fi
    proj=`echo $dir | cut -d / -f 3`
    beginning="$letter/$proj"
    end=`echo "$dir" | rev | cut -d / -f1 | rev`

    if [[ $proj == "" ]]; then
      workingdir="$dir"
    elif [[ $proj == "~" ]]; then
      workingdir="$dir"
    elif [[ $dir =~ "$first/$proj"$ ]]; then
      workingdir="$beginning"
    elif [[ $dir =~ "$first/$proj/$end"$ ]]; then
      workingdir="$beginning/$end"
    else
      workingdir="$beginning/… /$end"
    fi
  else
    workingdir="$dir"
  fi

  echo -e "$workingdir"
}

autoload -U colors && colors
autoload -U promptinit && promptinit
promptinit

echo $colors
# Gen PS1
precmd()
{
  local EXIT=$?
  PROMPT=""
  ZSH_THEME_GIT_PROMPT_PREFIX="(%{%F{green}%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
  ZSH_THEME_GIT_PROMPT_DIRTY="%{%F{yellow}%}!"
  ZSH_THEME_GIT_PROMPT_UNTRACKED="%{%F{magenta}%}?"
  ZSH_THEME_GIT_PROMPT_CLEAN=""

  # Return code of last command
  if [[ $EXIT != 0 ]]; then
    PROMPT+="%{%F{red}%}✗ "
  else
    PROMPT+="%{%F{green}%}✔ "
  fi
  PROMPT+="%{%B%F{white}%}[%{%b%F{white}%}%*%{%B%F{white}%}]%{$reset_color%}" # [hh:mm:ss]
  PROMPT+="%{%F{blue}%} %n%{$reset_color%}"
  PROMPT+="%{%B%F{white}%} @ %{$reset_color%}"
  PROMPT+="%{%F{yellow}%}%M%{$reset_color%}"
  PROMPT+="%{%B%F{white}%} : %{$reset_color%}"
  PROMPT+="%{%F{white}%}$(shrink_cwd)%{$reset_color%} $(git_prompt_info)
%{%F{white}%}%# %{$reset_color%}"

  # Jobs, if any
  RPROMPT="%{%(1j.%B%F{white}%}[%{%b%F{white}%}%j%{%B%F{white}%}]%{$reset_color.)%}" # [#jobs]
}
