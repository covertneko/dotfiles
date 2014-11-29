## Fancy Prompt
# Responsive directory length taken from https://github.com/jondavidjohn/dotfiles

autoload -U colors promptinit
colors
promptinit

source $ZSH/git.zsh
ZSH_THEME_GIT_PROMPT_DIRTY="%{%F{yellow}%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{%F{red}%}?%{$reset_color%}"
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

  # Return code of last command as a check/x
  if [[ $EXIT != 0 ]]; then
    PROMPT+="%{%F{red}%}✗ "
  else
    PROMPT+="%{%F{green}%}✔ "
  fi
  # [hh:mm:ss]
  PROMPT+="%{%B%F{white}%}[%{%b%F{white}%}%*%{%B%F{white}%}]%{$reset_color%}"
  # user @ host : dir
  PROMPT+="%{%F{blue}%} %n%{$reset_color%}"
  PROMPT+="%{%B%F{white}%} @ %{$reset_color%}"
  PROMPT+="%{%F{yellow}%}%M%{$reset_color%}"
  PROMPT+="%{%B%F{white}%} : %{$reset_color%}"
  PROMPT+="%{%F{white}%}$(shrink_cwd) %{$reset_color%}"
  # (commitid:branch!?)
  PROMPT+=$(print_if_git "(%G%b%F{magenta}%}$(git_prompt_commit_id)%{$reset_color%}:%G%b%F{green}%}$(git_prompt_branch)%{$reset_color%}$(git_prompt_dirty))")
  # % on next line
  PROMPT+="
%{%F{white}%}%# %{$reset_color%}"

  # [#jobs], if any, shown on the right
  RPROMPT="%{%(1j.%B%F{white}%}[%{%b%F{white}%}%j%{%B%F{white}%}]%{$reset_color.)%}"
}
