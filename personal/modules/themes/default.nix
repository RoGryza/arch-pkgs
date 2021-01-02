# A lot of this is inspired by https://github.com/atpotts/base16-nix
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.me.themes;

  inherit (attrsets) mapAttrsToList;
  inherit (strings) concatStringsSep escapeShellArg;

  hookPkgs = mapAttrsToList
    (name: hook: pkgs.writeShellScript "${name}-base16-hook" hook)
    cfg.hooks;
  # TODO move setTheme to its own derivation
  setTheme = pkgs.writeShellScriptBin "set-theme" ''
    set -euo pipefail

    CURRENT_THEME="${cfg.dataPath}/current-theme"

    if [ "$#" -eq 0 ]; then
      if [ -f "$CURRENT_THEME" ]; then
        # TODO check if CURRENT_THEME is still valid
        cat "$CURRENT_THEME"
      else
        echo "${cfg.defaultScheme}"
      fi
      exit 0
    elif [ "$#" -ne 1 ]; then
      echo "Usage: set-theme [THEME]"
      exit 1
    fi

    THEME="$1"
    # TODO check theme existence here

    mkdir -p "${cfg.dataPath}"
    echo "$THEME" > "$CURRENT_THEME"

    ${concatStringsSep "\n" (map (hook: "${hook} $THEME") hookPkgs)}
  '';
in {
  imports = [ ./base16.nix ];

  options.me.themes = {
    enable = mkEnableOption "enable";

    hooks = mkOption {
      type = with types; attrsOf str;
      default = {};
    };

    dataPath = mkOption {
      type = types.str;
      default = "${config.xdg.dataHome}/base16-themes";
    };
  };
  # bat, Xresources, rofi, dunst, dwm-status?, drop old color dependencies

  # TODO refresh theme on configuration switch
  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ setTheme ];
    })
  ];
}
