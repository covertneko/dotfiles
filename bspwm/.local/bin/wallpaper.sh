#!/usr/bin/env bash
set -eo pipefail

state_dir="${XDG_STATE_DIR:-$HOME/.local/state}/wallpapers"
state_file="$state_dir/state.json"
wallpaper_dir=${1:-"/smb/nas1/erin/pictures/Wallpapers"}

mkdir -p "$state_dir"

if [ ! -f "$state_file" ]; then
  find "$wallpaper_dir" -type f -exec \
    magick identify -format '{ "path": "{}", "x": %w, "y": %h }' "{}" ";" |
    jq --slurp '{ "last_update": now|todateiso8601, "items": . }' > "$state_file"
fi

# Set a random wallpaper on each monitor specified on stdin
# TODO: consider replacing feh with something that has better multi monitor support
setWallpapers() {
    margin=0.1
    bg=()
    while IFS=, read -r name x y; do
        image="$(jq -r ".items[]|select(((.x/.y)-(${x}/${y})|fabs) < $margin)|.path" "$state_file" | shuf -n1)"
        xid=$(xrandr --listmonitors | sed -ne "s/\s\+\([0-9]\)\+:.*${name}/\1/p")
        # ensure images are ordered by xinerama monitor id, because feh is stupid
        bg[$xid]="$image"
    done

    args=()
    for i in "${bg[@]}"; do
        args+=(--bg-fill "$i")
    done

    # has to be run once for all monitors with images specified in order of xinerama id
    feh "${args[@]}" &
}

bspc wm -d |
jq -r '.monitors | map([.name, .rectangle.width, .rectangle.height] | join(",")) | join("\n")' |
setWallpapers
