HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=1000
# Vi master race
bindkey -v
setopt appendhistory
setopt autocd 
setopt beep 
setopt extendedglob 
setopt nomatch 
setopt notify 
# Directory stack
DIRSTACKSIZE=8
setopt autopushd 
setopt pushdminus 
setopt pushdsilent
setopt pushdtohome
