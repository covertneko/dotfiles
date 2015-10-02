# Additional user paths
set -l paths \
  "/usr/local/bin" \
  "/opt/local/bin" \
  "$HOME/.gem/ruby/2.2.0/bin" \
  "$HOME/.cabal/bin" \
  "$HOME/bin"
# Commands not to notify for when their jobs run longer than 10 seconds
set -g silentjobs "vim tmux screen man less more"

# Exports
set -x EDITOR vim
set -x VISUAL vim

# Add additional user paths
for p in $paths
  if not contains $p $PATH
    set -gx PATH $p $PATH
  end
end

if status --is-login
  # Set up ssh-agent on login if it isn't already running
  ssh_agent_start
end

set fish_color_cwd green

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

function fish_title
  if test "$_" != "fish"
    # If entering another job, save the name and time for the prompt later.
    set -g last_job "$_"
    set -g last_job_start (date +%s)
  end
  echo $_ ' '
  pwd
end

function before_prompt --on-event fish_prompt
    # Save the ending time if we're returning to the shell from a job.
    set -g last_job_end (date +%s)
end

function fish_prompt
  set -l last_status $status

  # Empty line
  echo

  if set -gq STY
    # For screen window titles
    echo -ne '\033k\033\\'
  end

  # Last job duration.
  if begin set -gq last_job last_job_start last_job_end
  and test -n "$last_job"; end
    # Ensure the job isn't in the "silentjobs" list.
    for j in $silentjobs
      if echo "$j" | egrep -q -- "$last_job"
        set -g last_job_silent
        break
      end
    end

    if not set -gq last_job_silent
      # Get the full command line of the last job.
      # This only works in fish 2.2b1+. $history[1] isn't set before fish_prompt
      # prior to that version :C. Using $last_job for now instead.
      #set -l last_cmd_line "$history[1]"
      set last_cmd_line "$last_job"

      # Calculate the duration of the last job.
      set -g last_job_duration (math $last_job_end-$last_job_start)

      # If last job took longer than 10 seconds, notify with snarl on Cygwin or
      # growl on OS X.
      if test $last_job_duration -gt 10
        if type growlnotify > /dev/null ^&1
          growlnotify -m "Returned $last_status, took $last_job_duration seconds." "$last_cmd_line" > /dev/null ^&1
        else if type heysnarl > /dev/null ^&1
          heysnarl "notify?title=$last_cmd_line&text=Returned $last_status, took $last_job_duration seconds." > /dev/null ^&1
        end
      end
    else
      # Erase it if it's set.
      set -ge last_job_silent
    end

    # Clean things up between jobs.
    set -ge last_job
    set -ge last_job_start
    set -ge last_job_end
  end

  # Print last status as failure or success, or time taken for longer commands.
  if test $last_status -gt 0
    set_color red
    if begin set -gq last_job_duration
    and test $last_job_duration -gt 10; end
      printf '%s' "$last_status, "$last_job_duration"s "
    else
      printf '%s' '✗ '
    end
    set_color normal
  else
    set_color green
    if begin set -gq last_job_duration
    and test $last_job_duration -gt 10; end
      test $last_job_duration -gt 10
      printf '%s' "$last_status, "$last_job_duration"s "
    else
      printf '%s' '✓ '
    end
    set_color normal
  end

  # 24 hour timestamp
  set_color white
  printf '%s' "["(date +"%H:%M:%S")"] "

  # user @ hostname
  set_color blue
  printf '%s ' (whoami)
  set_color white
  printf '%s' "@ "
  set_color yellow
  if test -e /etc/hostname
    printf '%s ' (cat /etc/hostname)
  else
    printf '%s ' (hostname)
  end

  # : cwd
  set_color white
  printf '%s' ": "
  set_color $fish_color_cwd
  printf '%s ' (prompt_pwd)
  set_color normal

  # New line with '>' for the command line
  echo -e '\n> '
end

# Show git status on the right-hand side
function fish_right_prompt
  set -l _up '\e[1A'
  set -l _down '\e[1B'

  # Move the cursor up so the git status isn't on the same line that commands
  # are typed on.
  echo -e $_up

  printf '%s ' (__fish_git_prompt)
  set_color normal

  # And back down to the ">"
  echo -e $_down
end
