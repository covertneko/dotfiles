{ config, pkgs, lib, ... }:
{
  options.hypervisor.vfio = {
    enable = lib.mkEnableOption "Enable VFIO and pass through configured PCI devices";
    headless = lib.mkEnableOption "Enable headless mode (unbind boot GPU to allow passthrough)";
    deviceIds = lib.mkOption {
      default = [ ];
      type = with lib.types; listOf str;
      description = "Device IDs for vfio-pci";
    };
  };

  config =
    # TODO: review how nested modules are handled in nixpkgs and do this properly
    let cfg = config.hypervisor.vfio;
    in {
      boot = {
        initrd.kernelModules = [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
          "vfio_virqfd"

          "amdgpu"
        ];

        kernelParams = lib.optionals cfg.enable ([
          "iommu=pt"
          ("vfio-pci.ids=" + lib.concatStringsSep "," cfg.deviceIds)
        ] ++ lib.optionals cfg.headless [
          # Ensure that the boot gpu is never bound by the host
          # Disable efi framebuffer and blacklist all video modules
          # TODO: provide means to reset vbios?
          "quiet"
          "textonly"
          "video=vesafb:off"
          "video=efifb:off"
          "module_blacklist=nvidia,nouveau,amdgpu"
        ]);
      };
    };
}
