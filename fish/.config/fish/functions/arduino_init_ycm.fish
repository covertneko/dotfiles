function arduino_init_ycm
	set -l config "$HOME/.local/lib/platformio/arduino/.ycm_extra_conf.py"

  if test -e $config
    cp $config ./
  else
    curl -o $config https://gist.githubusercontent.com/nikelmwann/a8ea169036adbdb83b8b/raw/8230063d651bcb8eb71036b615fb65ef7f51d62d/.ycm_extra_conf.py
    arduino_init_ycm
  end
end
