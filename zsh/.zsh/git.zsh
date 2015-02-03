## Git Stuff
# Git prompt info mostly taken from Steve Losh's fork of oh-my-zsh
# https://github.com/sjl/oh-my-zsh/blob/master/lib/git.zsh
function print_if_git()
{
  git branch > /dev/null 2> /dev/null && echo $1
}

function git_prompt_branch()
{
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

function git_prompt_commit_id()
{
  id=$(git rev-parse HEAD 2> /dev/null) || return
  echo $(echo $id | head -c 6)
}

function git_prompt_dirty()
{
  gitstat=$(git status 2>/dev/null | egrep '(Untracked|Changes|Changed but not updated:)')
  if [[ $(echo ${gitstat} | egrep -c "Changes to be committed:$") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_DIRTY"
  fi

  if [[ $(echo ${gitstat} | egrep -c "(Untracked files:$|Changed but not updated:$|Changes not staged for commit:$)") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi 

  if [[ $(echo ${gitstat} | wc -l | tr -d ' ') == 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}
