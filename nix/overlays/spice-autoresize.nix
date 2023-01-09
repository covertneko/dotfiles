final: curr:
let
  script = curr.writeShellScriptBin "spice-autoresize" ''
    export DISPLAY=:0
    export XAUTHORITY=/home/erin/.Xauthority
    xrandr --output $(xrandr | awk '/ connected/{print $1; exit; }') --auto
  '';
  scriptDeps = with curr; [ gawk xorg.xrandr ];
in {
  spice-autoresize = curr.symlinkJoin {
    name = "spice-autoresize";
    version = "0.1.0";
    paths = [ script ] ++ scriptDeps;
    buildInputs = [ curr.makeWrapper curr.udev ];
    postBuild = ''
      wrapProgram $out/bin/spice-autoresize --prefix PATH : $out/bin

      mkdir -p $out/lib/udev/rules.d
      cat <<- EOF > $out/lib/udev/rules.d/50-spice-autoresize.rules
      SUBSYSTEM=="drm", ACTION=="change", KERNEL=="card0", RUN+="$out/bin/spice-autoresize"
      EOF
    '';
  };
}
