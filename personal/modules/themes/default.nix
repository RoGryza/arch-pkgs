# A lot of this is inspired by https://github.com/atpotts/base16-nix
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.me.themes;

  inherit (attrsets) mapAttrsToList;
  inherit (strings) concatStringsSep escapeShellArg;

  consumerScripts = mapAttrsToList
    (name: { hook, template }: pkgs.writeShellScript "${name}-base16-hook" ''
      set -euo pipefail

      export THEME="${cfg.consumerBase16Dirs.${name}}/$1"
      if [ ! -f "$THEME" ]; then
        echo "Theme '$1' not found for '${name}'"
        exit 1
      fi

      ${hook}
    '')
    cfg.consumers;
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

    ${concatStringsSep "\n" (map (hookPkg: "${hookPkg} $THEME") consumerScripts)}
  '';
in {
  imports = [ ./base16.nix ];

  options.me.themes = {
    enable = mkEnableOption "enable";

    consumers = mkOption {
      type = with types; attrsOf (submodule {
        options = {
          hook = mkOption { type = str; };
          template = mkOption { type = types.package; };
        };
      });

      default = {};
    };
    consumerBase16Dirs = mkOption {
      type = with types; attrsOf package;
      readOnly = true;
    };

    configPath = mkOption {
      type = types.str;
      default = "${config.xdg.configHome}/base16-themes";
    };
    dataPath = mkOption {
      type = types.str;
      default = "${config.xdg.dataHome}/base16-themes";
    };
    setTheme = mkOption {
      type = types.str;
      default = "${setTheme}/bin/set-theme";
    };
  };
  # bat, Xresources, vim, dwm-status?, drop old color dependencies

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ setTheme ];
      me.themes.consumerBase16Dirs = flip mapAttrs cfg.consumers
        (name: { template, ... }: config.lib.base16.dir name template);
    })
  ];
}
