## Fancy Prompt
# Responsive directory length taken from https://github.com/jondavidjohn/dotfiles

autoload -U colors promptinit
colors
promptinit

source git.zsh
ZSH_THEME_GIT_PROMPT_PREFIX="(%{%F{green}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{%F{yellow}%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{%F{magenta}%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

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

precmd()
{
  local EXIT=$?
  PROMPT=""

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
