{ config, pkgs, ... }:
{
  nix.nixPath = [ "nixpkgs=${pkgs.path}" ];

  environment.systemPackages = with pkgs; [
    file
    neovim
    nodejs
    rustup
    zsh
    fish
    stow
    tree
    bottom
  ];

  nixpkgs.overlays = [
  ];
  nixpkgs.config.allowUnfree = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.variables = {
    EDITOR = "nvim";
  };

  nix.registry.nixpkgs.to = {
    type = "path";
    path = toString pkgs.path;
  };
}
