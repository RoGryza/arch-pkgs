{ config, lib, pkgs, ... }:
with lib;
let
  inherit (builtins) readFile;

  xresourcesThemes = config.lib.base16.templates {
    app = "Xresources";
    template = pkgs.writeText "xresources-base16-template" (readFile ./xresources.mustache);
    installPhase = ''mkdir -p $out'';
    install = name: package: ''ln -s ${package} $out/${name}'';
  };
  xresourcesDefaults = pkgs.writeText "xresources-defaults" ''
    *.font: DejaVu Sans Mono:pixelsize=18
  '';
in {
  me.themes.hooks.xresources = ''
    cat "${xresourcesDefaults}" "${xresourcesThemes}/$1" | xrdb -merge
  '';
}
