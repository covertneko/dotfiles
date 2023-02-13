{ config, lib, pkgs, ... }: {
  imports = [
    ../../roles/dev
    ../../roles/linux
    ../../roles/users
    ../../roles/bspwm
    ./hardware-configuration.nix
  ];

#  boot.initrd.availableKernelModules = [ "aesni_intel" "cryptd" ];
  # create a swap file on the encrypted partition
#  swapDevices = [{ device = "/swap/swapfile"; size = 16384; }];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  services.xserver.enableCtrlAltBackspace = true;

  networking.hostName = "lynx";

  boot.extraModulePackages = with config.boot.kernelPackages; [ kvmfr ];
  boot.kernelModules = [ "kvmfr" ];
  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="erin", GROUP="kvm", MODE="0660"
  '';

  environment.systemPackages = with pkgs; [
    looking-glass-client
    virt-manager
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
