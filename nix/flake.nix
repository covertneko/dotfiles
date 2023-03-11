{
  description = "Computers with the nixos";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # latest for kicad 7.0.0 (until merged into unstable)
    # TODO: remove this when no longer needed
    # nixpkgs-kicad7.url = "github:evils/nixpkgs/9a9546ed3cc25f9223acd65a83f9d13550761328";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          # ((import ./overlays/kicad.nix) { inherit nixpkgs-kicad7; })
          (import ./overlays/3dslicer.nix)
          (import ./overlays/spotify-player.nix)
          (import ./overlays/fonts.nix)
        ];
      } // { outPath = nixpkgs.outPath; };
    in
    {
      nixosConfigurations.lynx = nixpkgs.lib.nixosSystem {
        inherit pkgs system;
        modules = [ ./machines/lynx ];
      };
      nixosConfigurations.serval = nixpkgs.lib.nixosSystem {
        inherit pkgs system;
        modules = [ ./machines/serval ];
      };
    };
}
