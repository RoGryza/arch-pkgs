{ sources ? import ./sources.nix }:
let
  overlay = _: pkgs: {
    niv = (pkgs.callPackage sources.niv {}).niv;
    vimPlugins.deoplete-vim-lsc = pkgs.vimUtils.buildVimPlugin {
      pname = "deoplete-vim-lsc";
      src = sources.deoplete-vim-lsc;
    };
  };
in
  import sources.nixpkgs { overlays = [overlay]; config = {
    allowUnfree = true;
  }; }
