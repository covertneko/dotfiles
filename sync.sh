#!/usr/bin/env zsh
autoload -U colors && colors
## Sync dotfiles to home
cd "$(dirname "${BASH_SOURCE}")"

echo -e "$fg[green]Syncing with git repo . . .$reset_color"
git pull origin master

# Sync and delete extraneous files from locations in mirror.txt
echo -e "$fg[green]Syncing mirror directories . . .$reset_color"
rsync -avhr --no-perms --delete --filter="merge rules.txt" --files-from="mirror.txt" $@ . $HOME

# Sync the rest without deleting
echo -e "$fg[green]Syncing remaining files . . .$reset_color"
rsync -avh --no-perms --filter="merge rules.txt" --exclude-from="mirror.txt" $@ . $HOME
