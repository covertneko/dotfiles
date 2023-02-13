{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    system-config-printer
  ];

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    openFirewall = true;
    nssmdns = true;
  };
  services.ipp-usb.enable = true;
  services.printing.drivers = with pkgs; [ gutenprint gutenprintBin ];
}
