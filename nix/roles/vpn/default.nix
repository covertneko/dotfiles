{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    samba
    cifs-utils
  ];

  services.tailscale.enable = true;

  # use autofs with smb autodiscovery
  # NOTE: requires credentials (see auto.smb)
  # TODO: stop using smb
  services.autofs = {
    enable = true;
    debug = true;
    autoMaster = let
    # copied from samples; TODO: move to separate file
      mapConf = with pkgs; symlinkJoin {
        name = "auto.smb";
        paths = [
          (pkgs.writeScriptBin "auto.smb" (builtins.readFile ./auto.smb))
          samba
          gawk
        ];
        buildInputs = [ makeWrapper ];
        postBuild = "wrapProgram $out/bin/auto.smb --prefix PATH : $out/bin";
      };
      in ''
        /smb ${mapConf}/bin/auto.smb --timeout=300
      '';
  };
}
