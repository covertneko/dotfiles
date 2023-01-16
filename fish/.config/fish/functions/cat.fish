function cat --wraps=bat --description 'alias cat=bat'
    if command -v bat &>/dev/null
        bat $argv
    else
        cat $argv
    end
end
