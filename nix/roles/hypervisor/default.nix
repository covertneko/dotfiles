{ config, pkgs, lib, ... }:
with lib;
{
  options.hypervisor = {
    # TODO: figure out how to organize this
    # vfio = types.submodule (import ./vfio.nix);
    guests = mkOption {
      default = [ ];
      type = types.attrsOf (types.submodule (import ./domain.nix));
      description = "Libvirt domains to define";
    };
  };

  imports = [
    ./vfio.nix
  ];

  config =
    let
      cfg = config.hypervisor;
      libvirt = pkgs.libvirt;
    in
    {
      hardware.opengl.enable = true;
      virtualisation = {
        libvirtd = {
          enable = true;

          # NOTE: edk2 and OVMF version 202211 breaks IVSHMEM
          # See: https://github.com/gnif/LookingGlass/issues/1051
          # TODO: move this to machine config
          qemu.ovmf.packages = [
            (pkgs.OVMF.override {
              edk2 = pkgs.edk2.overrideAttrs (oldAttrs: rec {
                version = "202205";
                src = fetchFromGitHub {
                  owner = "tianocore";
                  repo = "edk2";
                  rev = "edk2-stable${version}";
                  fetchSubmodules = true;
                  sha256 = "sha256-5V3gXZoePxRVL0miV/ku/HILT7d06E8UI28XRx8vZjA=";
                };
              });
            }).fd
          ];
        };

        spiceUSBRedirection.enable = true;
      };

      # {
      #   serviceConfig = {
      #     ExecStart = { };
      #   };
      #   bindsTo = "libvirtd.sock";
      #   after = "libvirtd.sock";
      # } //
      systemd.services = mapAttrs'
        (name: value:
          let
            domain = pkgs.stdenv.mkDerivation {
              name = "${name}-domainxml";

              # TODO: combine?
              buildInputs = [ pkgs.libxslt pkgs.libvirt ];

              # merge template with generated config
              builder = builtins.toFile "builder.sh" ''
                source $stdenv/setup

                mkdir $out

                cp "${value.template}" ./template.xml

                echo "merging domain configuration for ${name}"
                echo "$domainOptions" |
                xsltproc -v --path "." --param name "'${name}'" "${./options.xsl}" - |
                tee $out/domain.xml

                echo "validating domain configuration for ${name}"
                virt-xml-validate $out/domain.xml domain
              '';

              domainOptions = builtins.toXML value;
            };
          in
          # define systemd unit to ensure domain config is always correct
          nameValuePair "guest-config-${name}" {
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart =
                let
                  # FIXME: review timing of autostarted guests - docs are
                  # unclear but they may start before config is updated in the
                  # event of a reboot into a different generation, resulting in
                  # incorrect config for the autostarted vm.
                  autostart = if value.autostart then "" else "--disable";
                  # TODO: support specifying a libvirt connection uri?
                  script = pkgs.writeScript "guest-config-start" ''
                    #!${pkgs.runtimeShell}
                    set -eo pipefail
                    domain="$1"
                    ${libvirt}/bin/virsh define "$domain/domain.xml"
                    ${libvirt}/bin/virsh autostart ${autostart} "${name}"
                  '';
                in
                "${script} ${domain}";
            };
            # FIXME: this doesn't seem to automatically start when switching configurations
            # without either a reboot, manual start, or restart of libvirtd.
            # maybe I misunderstand how nixos determines which units to start when switching?
            wantedBy = [ "libvirtd.service" ];
            bindsTo = [ "libvirtd.socket" ];
            after = [ "libvirtd.socket" ];
            # NOTE: domain config is updated immediately but most changes will
            # not take effect until the guest in question is rebooted
            restartIfChanged = true;
          })
        cfg.guests;

      # system.activationScripts.hypervisor-domains = concatMapStrings
      #   (guest:
      #     let
      #       domain = pkgs.runCommand
      #         "hypervisor.domains.${guest.name}.config-validated"
      #         { nativeBuildInputs = [ libvirt ]; }
      #         ''
      #           ${libvirt}/bin/virt-xml-validate ${guest.config} domain
      #           cat ${guest.config} > $out
      #         '';
      #     in
      #     ''
      #       ${libvirt}/bin/virsh define ${domain}
      #     '')
      #   cfg.guests;
    };

  # environment.systemPackages = with pkgs; [
  # ];
}
