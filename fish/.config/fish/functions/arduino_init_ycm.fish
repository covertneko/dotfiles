function arduino_init_ycm
	set -l config "$HOME/lib/platformio/arduino/.ycm_extra_conf.py"

  if test -e $config
    cp $config ./
  else
    curl -o $config https://gist.github.com/ajford/f551b2b6fd4d6b6e1ef2
    arduino_init_ycm
  end
end
