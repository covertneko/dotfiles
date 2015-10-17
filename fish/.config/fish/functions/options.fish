function options
	# Parse command line options
  # https://stackoverflow.com/a/16679919

  # Pad argv with a space to prevent echo from intepreting an option as its own
  # like "-h".
  echo " $argv" | sed 's|--*|\\'\n'|g' | grep -v '^$'
end
