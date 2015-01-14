#!/usr/bin/env bash
# Symlinks all top-level files and directories to $HOME
DOTFILESDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Files not to link
IFS=$'\n' read -rd '' -a ignore <<< $(cat ignore.txt)

function in_array()
{
  local array="$1[@]"
  local value=$2
  local result=1

  for e in ${!array}; do
    if [[ $e == $value ]]; then
      result=0
      break
    fi
  done
  return $result
}

function link()
{
  local name=$1
  cd $HOME

  if in_array ignore $name; then
    echo "Ignoring $name."
  elif [[ -e $name ]]; then
    if [[ -L "$HOME/$name" ]] && [[ $(readlink "$HOME/$name") == "$DOTFILESDIR/$name" ]]; then
      echo "$HOME/$name exists and already links to $DOTFILESDIR/$name"
    else
      echo "$HOME/$name exists! Delete $HOME/$name and create symlink?"
      read choice
      if [[ $choice =~ ^([yY][eE][sS])|[yY]$ ]]; then
        echo "Deleting and linking ${name}..."
        rm -rf $name
        ln -s $DOTFILESDIR/$name $name
      fi
    fi
  else
    echo "Linking ${name}..."
    ln -s $DOTFILESDIR/$name $name
  fi
}

for f in $(ls -a | tail -n +3); do
  link $f
done
