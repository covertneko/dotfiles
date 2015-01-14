set __fish_git_prompt_show_informative_status 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch green
set __fish_git_prompt_color_flags white
set __fish_git_prompt_color_stagedstate green
set __fish_git_prompt_color_dirtystate yellow
set __fish_git_prompt_color_untrackedfiles red
set __fish_git_prompt_color_upstream white
set __fish_git_prompt_color_cleanstate green

function fish_prompt
  set last_status $status

  if test $last_status -gt 0
    set_color red
    printf '%s' '✗ '
    set_color normal
  else
    set_color green
    printf '%s' '✓ '
    set_color normal
  end

  set_color white
  printf '%s' "["(date +"%H:%M:%S")"] "

  set_color blue
  printf '%s ' (whoami)
  set_color white
  printf '%s' "@ "
  set_color yellow
  printf '%s ' (hostname)
  set_color white
  printf '%s' ": "

  set_color $fish_color_cwd
  printf '%s ' (prompt_pwd)
  set_color normal
  
  echo -e '\n> '
end

function fish_right_prompt
  set -l _up '\e[1A'
  set -l _down '\e[1B'

  echo -e $_up
  
  printf '%s ' (__fish_git_prompt)
  set_color normal

  echo -e $_down
end
