{ config, pkgs , ... }:
let sources = import ./nix/sources.nix;
in
{
  imports = [
    ../base
  ];

  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_US.UTF-8";

  # security
  services.openssh = {
    enable = true;
    settings = {
      permitRootLogin = "no";
      passwordAuthentication = false;
    };
    extraConfig = ''
      AcceptEnv COLORTERM LC_*
    '';
  };
  security.sudo.extraRules = pkgs.lib.mkAfter [
    { groups = [ "wheel" ]; commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }]; }
  ];

  # packages
  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    psmisc
    glibcLocales
    nixos-option

    stdenv

    # prefer procps over coreutils
    (lib.hiPrio procps)

    # FIXME: probably should be in a diff file
    sshfs
  ];

  programs.git.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;
  documentation.man.generateCaches = false;

  networking.networkmanager.enable = true;
  # NOTE: see https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  documentation.dev.enable = true;
}
