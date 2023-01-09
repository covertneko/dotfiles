function ll --wraps='ls -l' --wraps='exa -l' --description 'alias ll exa -l'
    exa -l $argv
end
