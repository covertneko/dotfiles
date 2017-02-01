function use-anaconda
	set -x PATH /opt/anaconda/bin $PATH
  source (conda info --root)/bin/conda.fish
end
