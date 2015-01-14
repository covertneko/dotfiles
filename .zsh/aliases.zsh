alias dhist='dirs -v'

# BSD or GNU ls???
if ls --version 2> /dev/null | grep -q "coreutils"; then
  alias ls='ls --color=always'
else
  alias ls='ls -G'
fi
