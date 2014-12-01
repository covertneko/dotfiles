#!/usr/bin/env bash
## Sync dotfiles to home
cd "$(dirname "${BASH_SOURCE}")"

git pull origin master

# Sync and delete extraneous files from locations in mirror.txt
rsync -avhr --no-perms --delete --filter="merge rules.txt" --files-from="mirror.txt" $@ . $HOME

# Sync the rest without deleting
rsync -avh --no-perms --filter="merge rules.txt" --exclude-from="mirror.txt" $@ . $HOME
