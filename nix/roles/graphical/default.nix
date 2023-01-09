{ config, pkgs, lib, ... }:
{
  imports = [ ../fonts ];
  environment.systemPackages = with pkgs; [
    libinput
    firefox
    chromium
    lxappearance
    alacritty
    glxinfo
    yubikey-manager-qt
    xsel
    # wl-clipboard
    # zoom-us
    xdg-utils
    obs-studio
    kdenlive
    # spotify
    # libreoffice
    arandr

    # vscode

    pulseaudio
    pavucontrol

    # audacity
    webcord
    # spice-autoresize
  ];

  # gitk
  programs.git.package = pkgs.gitFull;

  hardware.pulseaudio.enable = lib.mkForce false;

  # services.udev.packages = [ pkgs.spice-autoresize ];

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  security.rtkit.enable = true;

  fonts.fonts = with pkgs; [
    # (nerdfonts.override { fonts = [ "Hack" "MPlus" ]; })
    mplus-outline-fonts-nf
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
}
