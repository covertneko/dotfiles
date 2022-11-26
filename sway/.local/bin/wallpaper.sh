#!/usr/bin/bash

state_dir="${XDG_STATE_DIR:-$HOME/.local/state}/wallpapers"
state_file="$state_dir/state.json"
wallpaper_dir="/smb/nas1/erin/pictures/Wallpapers"
outputs=$()

mkdir -p "$state_dir"

if [ ! -f "$state_file" ]; then
  find "$wallpaper_dir" -type f -exec \
    magick identify -format '{ "path": "{}", "x": %w, "y": %h }' "{}" ";" |
    jq --slurp '{ "last_update": now|todateiso8601, "items": . }' > "$state_file"
fi

# current=$(jq "$state_dir/state.json")
# available=$(find "$wallpaper_dir" -type f | magick identify )

while IFS=, read -r output x y; do
  ratio=$(bc -l <<<"$x / $y")
  margin=0.1
  # echo "$output $x $y $ratio $margin"
  image="$(jq -r ".items[]|select(((.x/.y)-($ratio)|fabs) < $margin)|.path" "$state_file" | shuf -n1)"

  swaymsg output "$output" bg "$image" fill
done < <(swaymsg -t get_outputs |
  jq -r 'map([.name, .rect.width, .rect.height] | join(",")) | join("\n")')
