{
  description = "Computers with the nixos";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    webcord.url = "github:fufexan/webcord-flake";
    webcord.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, webcord, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          webcord.overlays.default
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
