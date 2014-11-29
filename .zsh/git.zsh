## Git Stuff
# Taken from Steve Losh's fork of oh-my-zsh
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
