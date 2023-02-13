{
  description = "Computers with the nixos";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (import ./overlays/spotify-player.nix)
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
