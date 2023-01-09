function la --wraps=ls --wraps=exa --description 'List contents of directory, including hidden files in directory using long format'
    exa -la $argv
end
