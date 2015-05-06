function addgitignore
	
  for gi in $argv;
    wget -O- https://raw.githubusercontent.com/github/gitignore/master/$gi.gitignore >> .gitignore;
  end
end
