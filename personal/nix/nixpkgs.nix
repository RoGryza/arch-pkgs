{ sources ? import ./sources.nix }:
let
  overlay = _: pkgs: {
    home-manager = (pkgs.callPackage sources.home-manager {}).home-manager;
    niv = (pkgs.callPackage sources.niv {}).niv;
  };
in
  import sources.nixpkgs { overlays = [overlay]; config = {}; }

