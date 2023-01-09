{
  description = "Computers with the nixos";
  inputs = {
    # nixpkgs.url = "git+file:///home/erin/proj/dev/nixpkgs?ref=patched";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    webcord.url = "github:fufexan/webcord-flake";
    webcord.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, webcord }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          webcord.overlays.default
          (import ./overlays/spice-autoresize.nix)
          (import ./overlays/fonts.nix)
        ];
      };
    in
    {
      nixosConfigurations.lynx = nixpkgs.lib.nixosSystem {
        inherit pkgs system;
        modules = [ ./machines/lynx ];
      };
    };
}
