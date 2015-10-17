function arduino_init_ycm
	set -l config "$HOME/.local/lib/platformio/arduino/.ycm_extra_conf.py"

  if test -e $config
    cp $config ./
  else
    curl -o $config https://gist.githubusercontent.com/ajford/f551b2b6fd4d6b6e1ef2/raw/3bab0d36c667a02877b138219caa6bf7341ce7e1/.ycm_extra_conf.py
    arduino_init_ycm
  end
end
