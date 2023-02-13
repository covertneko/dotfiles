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
    xdg-utils
    xdg-user-dirs
    obs-studio
    kdenlive

    blender

    prismlauncher

    piper

    spotify-player
    pulseaudio
    pavucontrol

    super-slicer-latest

    kicad

    signal-desktop
    webcord
  ];

  # gitk
  programs.git.package = pkgs.gitFull;

  hardware.pulseaudio.enable = lib.mkForce false;

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

  services.ratbagd.enable = true;

  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
}
