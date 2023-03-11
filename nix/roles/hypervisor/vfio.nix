{ config, pkgs, lib, types, ... }:
{
  options.vfio.enable = lib.mkEnableOption "Enable VFIO and pass through configured PCI devices";
  options.vfio.deviceIds = lib.mkOption {
    default = [];
    type = with types; listOf str;
    description = "Device IDs for vfio-pci";
  };

  config = let cfg = config.vfio;
  in {
    boot = {
      initrd.kernelModules = [
      ];
      kernelParams = [
        "amd_iommu=on"
      ] ++ lib.optional cfg.enable
        ("vfio-pci.ids=" + lib.concatStringsSep "," cfg.deviceIds);
    };
  };
}
