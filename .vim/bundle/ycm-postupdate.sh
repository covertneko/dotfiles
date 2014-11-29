#/usr/bin/env bash
# Properly update YCM by rebuilding the compiled portion
cd ./YouCompleteMe
git submodule update --init --recursive
./install.sh --clang-completer --system-libclang --omnisharp-completer
