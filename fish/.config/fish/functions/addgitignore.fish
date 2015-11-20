function addgitignore
	# Print help if no arguments given
  if [ (count $argv) -eq 0 ]
    addgitignore --help
    return 1
  end

  # The repo to source gitignores from
  set -l gi_repo 'github/gitignore'

  # Options
  set -l options (options $argv)

  if [ (count $options) -gt 1 ]
    for i in $options
      echo $i | read -l option value

      switch $option
        case l list
          # List available gitignores
          curl -s "https://api.github.com/repos/$gi_repo/git/trees/master?recursive=1" \
            | jq --raw-output '.tree | .[] | .path' \
            | sed 's/\.gitignore//'
        case h help
          # Print help text
          echo '
Usage:
    addgitignore [-l|--list -h|--help] file1, file2, file...

    Where "fileN" is a name of a gitignore without the ".gitignore" extension.

Options:
    -h --help   Print this help text.
    -l --list   List available gitignores (from github/gitignore).'
      end
    end

    # Don't download anything if options given
    return
  end

  # Download specified gitignores and append their contents to ./.gitignore
  for gi in $argv;
    # Modify IFS to get around fish's inability to preserve newlines in variables
    set oldIFS "$IFS"
    set IFS ""
    set -l response (curl "https://raw.githubusercontent.com/$gi_repo/master/$gi.gitignore")
    set IFS "$oldIFS"

    # Ensure gitignore was found
    if [ $response = "Not Found" ]
      echo -e "\nERROR 404: $gi.gitignore not found."
    else
      echo $response >> ./.gitignore;
    end
  end
end
