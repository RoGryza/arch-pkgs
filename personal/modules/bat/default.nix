{ config, lib, pkgs, ... }:
with lib;
let
  themesCfg = config.me.themes;

  inherit (builtins) attrNames listToAttrs readFile;
  inherit (attrsets) mapAttrs';

  batThemes = config.lib.base16.templates {
    app = "bat";
    template = pkgs.writeText "tmTheme-base16-template" (readFile ./template.mustache);
    install = name: package: ''ln -s ${package} $out/themes/${name}.tmTheme'';
    installPhase = ''mkdir -p $out/themes'';
  };
in {
  home.packages = [ pkgs.bat ];
  me.themes.hooks.bat = ''
      echo "--theme=base16-$THEME" > ~/.config/bat/config
  '';
  xdg.configFile."bat/themes".source = "${batThemes}/themes";
  home.activation.bat-cache-build = hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${pkgs.bat}/bin/bat cache --build
  '';
}
