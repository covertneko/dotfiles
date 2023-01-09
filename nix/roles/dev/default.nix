{ pkgs, config, lib, ... }:
let
  pyPkgs = ppkgs: with ppkgs; [
    ipython
    ipython-sql
    # jacked on macos currently https://github.com/NixOS/nixpkgs/issues/185918
    # pgcli
    requests
    tkinter
    pyperclip

    pip
    yapf

    numpy
  ];

in
{
  environment.systemPackages = with pkgs; [
    nix-index
    nix-doc
    rnix-lsp
    nil
    nixpkgs-fmt
    nix-direnv
    direnv

    gitAndTools.delta
    git-revise
    git-absorb

    ripgrep
    dtach
    tmux
    gh
    fd
    gdb
    jq
    graphviz
    ctags
    broot
    bat
    exa

    msmtp

    (python3.withPackages pyPkgs)
  ];

  nixpkgs.overlays = [
  ];

  nix.extraOptions = lib.mkMerge [
    (lib.mkIf pkgs.stdenv.isLinux ''
      plugin-files = ${pkgs.nix-doc}/lib/libnix_doc_plugin.so
    '')
    (lib.mkIf pkgs.stdenv.isDarwin ''
      plugin-files = ${pkgs.nix-doc}/lib/libnix_doc_plugin.dylib
    '')
    ''
      # nix-direnv
      keep-outputs = true
      keep-derivations = true
    ''
  ];

  nix.trustedBinaryCaches = [
    "https://haskell-language-server.cachix.org"
  ];

  environment.pathsToLink = [
    "/share/nix-direnv"
  ];
}
