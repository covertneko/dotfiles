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



  environment.systemPackages = with pkgs; [
    sxhkd
    rofi
    alacritty

    libsForQt5.breeze-icons
    libsForQt5.breeze-qt5

    polybar
    picom

    # TODO: patch, this is quite out of date
    catppuccin-gtk
  ];
}
