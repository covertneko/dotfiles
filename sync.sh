#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE}")"
git pull origin master
rsync -avh --no-perms --exclude-from="exclude.txt" $@ . ~
