# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PROMPT_COMMAND=__prompt_command
export CLICOLOR="YES"
export EDITOR=vim

# Open file with vim in a specifically sized terminal window
function vimterm()
{
  # Somehow the spaces aren't spaces in $@ - terminator won't accept -e "vim $@"
  args=""
  for a in $@; do args+=$a; args+=" "; done
  terminator -b --layout=vimterm -e "vim $args" &> /dev/null & disown
}

# Continue vim session <arg1>.vim, if none specified ~/.vim/sessions/current.vim
function vimcont()
{
  local defaultSession="${HOME}/.vim/sessions/current.vim"
  local session="${HOME}/.vim/sessions/${1}.vim"

  if ! [[ -z $1 ]] && [[ -e $session ]]; then
    echo "Using session \"${session}\"..."
  elif [[ -e $defaultSession ]]; then
    if ! [[ -z $session ]]; then
      echo "Invalid session name \"${session}\" provided"
      echo "Using default session \"${defaultSession}\"..."
    fi
    session=$defaultSession
  else
    echo "Missing default session. Fix or use vimterm <file>."
    return 1;
  fi

  vimterm -S $session
}

alias ls='ls --color=auto'

# Directories to append to $PATH
paths=(
$HOME/.cabal/bin
)
for p in ${paths[@]}; do export PATH=$PATH:$p; done

# Responsive directory length
# Taken from https://github.com/jondavidjohn/dotfiles
working_directory()
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

# Gen PS1
function __prompt_command()
{
  local EXIT="$?"
  PS1=""

  local color=( #{{{
  '\[\e[0m\]' # 0 Default
  '\[\e[30m\]' # 1 Black
  '\[\e[31m\]' # 2 Red
  '\[\e[32m\]' # 3 Green
  '\[\e[33m\]' # 4 Yellow
  '\[\e[34m\]' # 5 Blue
  '\[\e[35m\]' # 6 Magenta
  '\[\e[36m\]' # 7 Cyan
  '\[\e[37m\]' # 8 Light Gray
  '\[\e[90m\]' # 9 Dark Gray
  '\[\e[91m\]' # 10 Light Red
  '\[\e[92m\]' # 11 Light Green
  '\[\e[93m\]' # 12 Light Yellow
  '\[\e[94m\]' # 13 Light Blue
  '\[\e[95m\]' # 14 Light Magenta
  '\[\e[96m\]' # 15 Light Cyan
  '\[\e[97m\]' # 16 White
  ) #}}}

  local bcolor=( #{{{
  '\[\e[1;0m\]' # 0 Default
  '\[\e[1;30m\]' # 1 Black
  '\[\e[1;31m\]' # 2 Red
  '\[\e[1;32m\]' # 3 Green
  '\[\e[1;33m\]' # 4 Yellow
  '\[\e[1;34m\]' # 5 Blue
  '\[\e[1;35m\]' # 6 Magenta
  '\[\e[1;36m\]' # 7 Cyan
  '\[\e[1;37m\]' # 8 Light Gray
  '\[\e[1;90m\]' # 9 Dark Gray
  '\[\e[1;91m\]' # 10 Light Red
  '\[\e[1;92m\]' # 11 Light Green
  '\[\e[1;93m\]' # 12 Light Yellow
  '\[\e[1;94m\]' # 13 Light Blue
  '\[\e[1;95m\]' # 14 Light Magenta
  '\[\e[1;96m\]' # 15 Light Cyan
  '\[\e[1;97m\]' # 16 White
  ) #}}}

  local bgcolor=( #{{{
  '\[\e[0m\]' # 0 Default
  '\[\e[40m\]' # 1 Black
  '\[\e[41m\]' # 2 Red
  '\[\e[42m\]' # 3 Green
  '\[\e[43m\]' # 4 Yellow
  '\[\e[44m\]' # 5 Blue
  '\[\e[45m\]' # 6 Magenta
  '\[\e[46m\]' # 7 Cyan
  '\[\e[47m\]' # 8 Light Gray
  '\[\e[0;100m\]' # 9 Dark Gray
  '\[\e[0;101m\]' # 10 Light Red
  '\[\e[0;102m\]' # 11 Light Green
  '\[\e[0;103m\]' # 12 Light Yellow
  '\[\e[0;104m\]' # 13 Light Blue
  '\[\e[0;105m\]' # 14 Light Magenta
  '\[\e[0;106m\]' # 15 Light Cyan
  '\[\e[0;107m\]' # 16 White
  ) #}}}

  local x='\342\234\227'
  local check='\342\234\223'

  # Return code of last command
  if [[ $EXIT != 0 ]]; then
    PS1+="${color[2]}$x "
  else
    PS1+="${color[3]}$check "
  fi
  PS1+="${bcolor[16]}[${color[0]}"
  PS1+="${color[16]}\t${color[0]}"
  PS1+="${bcolor[16]}] ${color[0]}"
  PS1+="${color[10]}\u${color[0]}"
  PS1+="${color[16]}@${color[0]}"
  PS1+="${color[12]}\h${color[0]}"
  PS1+="${bcolor[16]}:${color[0]}"
  PS1+="${color[5]}$(working_directory) ${color[0]}"
  PS1+="${color[16]}\$ ${color[0]}"
}
