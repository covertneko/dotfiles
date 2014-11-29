#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE}")"
rsync -avh --no-perms --exclude-from="exclude.txt" $@ . ~
