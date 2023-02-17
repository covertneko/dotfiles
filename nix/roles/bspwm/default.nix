{ config, pkgs, ... }:
{
  imports = [ ../graphical ];
  services.xserver = {
    enable = true;
    windowManager.bspwm.enable = true;
    displayManager.sddm.enable = true;

    displayManager.defaultSession = "bspwm";
    displayManager.sessionPackages = [
      (pkgs.writeTextFile {
        name = "bspwm-xsession";
        destination = "/share/xsessions/bspwm.desktop";
        text = ''
          [Desktop Entry]
          Version=1.0
          Type=XSession
          Name=bspwm
          Comment=Binary space partitioning window manager
          Exec=bspwm
        '';
      } // {
        providedSessions = [ "bspwm" ];
      })
    ];

    libinput.enable = true;
    libinput.touchpad.disableWhileTyping = true;
  };

  # TODO: idk maybe just remove this and set redshift location manually on every machine
  services.geoclue2 = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    arandr
    sxhkd
    polybar
    picom
    dunst
    rofi
    redshift
    xsecurelock
    xclip
    maim
    feh
    imagemagick
    pamixer

    xdotool
    xorg.xev
    xorg.xprop

    alacritty

    libsForQt5.breeze-icons
    libsForQt5.breeze-qt5

    (pkgs.catppuccin-gtk.override {
      accents = [ "mauve" ];
      size = "standard";
      variant = "mocha";
    })
  ];
}
