{ config, lib, pkgs, ... }: {
  imports = [
    ../../roles/dev
    ../../roles/linux
    ../../roles/users
    ../../roles/vpn
    ../../roles/hypervisor
    ./hardware-configuration.nix
  ];

  #  boot.initrd.availableKernelModules = [ "aesni_intel" "cryptd" ];
  # create a swap file on the encrypted partition
  #  swapDevices = [{ device = "/swap/swapfile"; size = 16384; }];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
  };

  hypervisor.guests = [
    {
      name = "nixos";
      config = ./nix.dump.xml;
    }
  ];

  vfio.enable = false;
  vfio.deviceIds = [
    # 2070 Super
    "10de:1e84"
    "10de:10f8"
    "10de:1ad8"
    "10de:1ad9"

    # GTX 760
    "10de:1187"
    "10de:0e0a"

    # RX 570
    "1002:67df"
    "1002:aaf0"

    # USB host controller (upper ports on rear IO)
    "1022:149c"
  ];

  specialisation.safe = {
    inheritParentConfig = true;

    configuration = {
      vfio.enable = false;
    };

    # TODO: disable VM autostart
  };

  networking.hostName = "serval";

  # environment.systemPackages = with pkgs; [
  # ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
