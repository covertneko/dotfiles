{
  description = "Computers with the nixos";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    {
      nixosConfigurations.catbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./machines/catbook ];
      };
    };
}
