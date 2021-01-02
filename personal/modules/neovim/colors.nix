{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.neovim;
  themesCfg = config.me.themes;

  inherit (builtins) readFile;

  colorsPlugin = pkgs.stdenv.mkDerivation (rec {
    name = "neovim-base16-colors";
    pname = name;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/share/vim-plugins/base16/colors
      for F in ${themesCfg.consumerBase16Dirs.neovim}/*; do
        ln -s "$F" "$out/share/vim-plugins/base16/colors/base16-$(basename $F).vim"
      done
    '';
  });
in
mkMerge [
  (mkIf cfg.enable {
    programs.neovim.plugins = [{
      plugin = colorsPlugin;
      config = ''
        if filereadable("${themesCfg.dataPath}/current-theme")
          let my_theme = readfile("${themesCfg.dataPath}/current-theme")[0]
        else
          let my_theme = "${themesCfg.defaultScheme}"
        endif
        execute "colorscheme base16-" . my_theme
      '';
    }];
    me.themes.consumers.neovim = {
      template = pkgs.writeText "neovim-base16-template" (readFile ./colors.mustache);
      # TODO live-reload color scheme
      hook = "";
    };
  })
]
