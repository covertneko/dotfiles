{ config, pkgs, lib, ... }:
with lib;
{
  options = {
    # TODO: builder to generate xml and merge with template
    template = mkOption {
      type = types.path;
    };
    autostart = mkOption {
      type = types.bool;
      default = false;
    };

    # See https://libvirt.org/formatdomain.html#host-device-assignment
    hostDevices = mkOption {
      type = (types.submodule {
        options = {
          pci = mkOption {
            type = types.listOf (types.submodule {
              options = {
                bus = mkOption { type = types.str; };
                slot = mkOption { type = types.str; };
                functions = mkOption { type = types.listOf types.str; };
              };
            });
          };

          usb = mkOption {
            type = types.listOf
              (types.submodule {
                options = {
                  vendorId = mkOption { type = types.str; };
                  productId = mkOption { type = types.str; };

                  startupPolicy = mkOption {
                    type = types.enum [ "mandatory" "requisite" "optional" ];
                    default = "mandatory";
                  };

                  guestReset = mkOption {
                    type = types.nullOr (types.enum [ "off" "uninitialized" "on" ]);
                    default = null;
                  };

                  # TODO: support specifying bus address
                };
              });
            default = [ ];
          };
        };
      });
    };
  };
}
