function scaffold
	set cwd (pwd)

	if test -z $LOCAL_SCAFFOLD_PATH
    set LOCAL_SCAFFOLD_PATH "$HOME/.local/lib/skel"
  end

  for d in $argv
    set -l dir "$LOCAL_SCAFFOLD_PATH/$d"

    if test -d $dir
      echo "Copying files from $dir..."

      # Make sure hidden files get copied by using find
      set -l files (find $dir -maxdepth 1 ! -path $dir)

      cp --preserve=mode --recursive --interactive --verbose $files $cwd
    else
      echo "Directory `$d` does not exist in `$LOCAL_SCAFFOLD_PATH`."
    end
  end
end
