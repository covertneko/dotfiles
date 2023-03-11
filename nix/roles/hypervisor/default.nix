{ config, pkgs, lib, ... }:
with lib;
{
  imports = [
    ./vfio.nix
  ];

  options.hypervisor.guests = mkOption {
    default = [ ];
    type = types.listOf (types.submodule {
      options = {
        name = mkOption {
          type = types.str;
        };
        config = mkOption {
          type = types.path;
        };
      };
    });
    description = "Libvirt domains to define";
  };

  config =
    let
      cfg = config.hypervisor;
      libvirt = pkgs.libvirt;
    in
    {
      hardware.opengl.enable = true;
      virtualisation = {
        libvirtd.enable = true;
        spiceUSBRedirection.enable = true;
      };

      system.activationScripts.hypervisor-domains = concatMapStrings
        (guest:
          let
            domain = pkgs.runCommand
              "hypervisor.domains.${guest.name}.config-validated"
              { nativeBuildInputs = [ libvirt ]; }
              ''
                ${libvirt}/bin/virt-xml-validate ${guest.config} domain
                cat ${guest.config} > $out
              '';
          in
          ''
            ${libvirt}/bin/virsh define ${domain}
          '')
        cfg.guests;
    };

  # environment.systemPackages = with pkgs; [
  # ];
}
