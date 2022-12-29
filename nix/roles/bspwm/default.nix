{ config, pkgs, ... }:
{
  imports = [ ../graphical ];
  services.xserver = {
    enable = true;
    windowManager.bspwm.enable = true;
    displayManager.startx.enable = true;

    libinput.enable = true;
    libinput.touchpad.disableWhileTyping = true;
  };

  services.picom.enable = true;

  environment.systemPackages = with pkgs; [
    sxhkd
    rofi
    alacritty

    libsForQt5.breeze-icons
    libsForQt5.breeze-qt5

    catppuccin-gtk
  ];
}
