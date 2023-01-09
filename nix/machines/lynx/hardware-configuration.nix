# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  nixpkgs.config.allowUnfree = true;
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "usbhid" "sr_mod" "virtio_blk" "virtio_scsi" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Fix f-keys on shitty keyboard
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=0
  '';

  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = [pkgs.mesa.drivers];
  };

  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = true;

  services.xserver.videoDrivers = [ "amdgpu" "mesa" ];

  environment.systemPackages = with pkgs; [
    mesa
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b40817f4-a67d-46d7-85a9-b060dcbb075d";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/8C7B-E4E0";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/96707e40-8a9f-465c-b34a-170d12dfd290"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}