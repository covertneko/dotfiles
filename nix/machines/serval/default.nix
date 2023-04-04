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

  hypervisor = {
    guests = {
      # NixOS workstation
      lynx = {
        template = ./lynx.xml;
        autostart = lib.mkDefault true;
        hostDevices.pci = [
          # Upper rear panel USB ports
          { bus = "11"; slot = "00"; functions = [ "3" ]; }

          # RX 570
          { bus = "0e"; slot = "00"; functions = [ "0" "1" ]; }
        ];
      };

      # Windows 10
      hotgarbage = {
        template = ./hotgarbage.xml;
        hostDevices.pci = [
          # RTX 2070 Super
          { bus = "0f"; slot = "00"; functions = [ "0" "1" "2" "3" ]; }
        ];
        hostDevices.usb = [
          # DS4 bluetooth adapter
          { vendorId = "054c"; productId = "0ba0"; startupPolicy = "optional"; }
        ];
      };
    };

    vfio = {
      enable = lib.mkDefault true;
      headless = true;
      deviceIds = [
        # RTX 2070 Super
        "10de:1e84"
        "10de:10f8"
        "10de:1ad8"
        "10de:1ad9"

        # GTX 760
        #"10de:1187"
        #"10de:0e0a"

        # RX 570
        "1002:67df"
        "1002:aaf0"

        # AMD USB Host Controller
        "1022:149c"
      ];
    };
  };

  # Safe mode with vfio and autostart disabled
  specialisation.safe = {
    inheritParentConfig = true;

    configuration.hypervisor = {
      vfio.enable = false;
      guests.lynx.autostart = false;
    };

    # TODO: disable VM autostart
  };

  networking.hostName = "serval";
  networking.interfaces.enp9s0.useDHCP = true;
  networking.interfaces.br0.useDHCP = true;
  networking.bridges = {
    br0 = {
      interfaces = [ "enp9s0" ];
    };
  };

  networking.hostId = "d8adf964";
  boot.supportedFilesystems = [ "zfs" ];

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
