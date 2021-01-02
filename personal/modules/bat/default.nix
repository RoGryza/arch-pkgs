{ config, lib, pkgs, ... }:
with lib;
let
  themesCfg = config.me.themes;

  inherit (builtins) attrNames listToAttrs readFile;
  inherit (attrsets) mapAttrs';
in {
  home.packages = [ pkgs.bat ];
  me.themes.consumers.bat = {
    template = pkgs.writeText "tmTheme-base16-template" (readFile ./template.mustache);
    hook = ''
      echo "--theme=base16-$(basename $THEME)" > ~/.config/bat/config
    '';
  };
  xdg.configFile = mkMerge [
    (listToAttrs (flip map (attrNames themesCfg.schemes)
      (name: {
        name = "bat/themes/base16-${name}.tmTheme";
        value.source = "${themesCfg.consumerBase16Dirs.bat}/${name}";
      })))
  ];
  home.activation.bat-cache-build = hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${pkgs.bat}/bin/bat cache --build
  '';
}
