function ll --wraps='ls -l' --wraps=ls --wraps=exa --wraps='exa -l'
    if command -v &>/dev/null exa
        exa -l $argv
    else
        ls -l $argv
    end
end
