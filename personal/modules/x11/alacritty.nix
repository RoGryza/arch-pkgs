{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.alacritty;
  # TODO use an overlay...
  sources = import ../../nix/sources.nix;
  # TODO expose config option to pick nixGL wrapper
  nixGLNvidia = (import sources.nixGL { inherit pkgs; }).nixGLNvidia;
  yamlFormat = pkgs.formats.yaml { };

  lightTheme = yamlFormat.generate "light.yml" (cfg.defaultSettings // cfg.themes.light);
  darkTheme = yamlFormat.generate "dark.yml" (cfg.defaultSettings // cfg.themes.dark);

  themePath = "${config.xdg.configHome}/alacritty/current-theme";
  settingsPath = "${config.xdg.configHome}/alacritty/alacritty.yml";
  # TODO: move toggle-theme to an overlay
  toggleTheme = pkgs.writeShellScriptBin "toggle-theme" ''
    set -euo pipefail

    if [ "$#" -ge 1 ]; then
      THEME="$1"
    elif [ ! -f "${themePath}" ]; then
      mkdir --parents "$(dirname "${themePath}")"
      THEME=dark
    else
      if [ "$(cat "${themePath}")" = light ]; then
        THEME=dark
      else
        THEME=light
      fi
    fi
    if [ "$THEME" = light ]; then
      SRC="${lightTheme}"
    else
      SRC="${darkTheme}"
    fi
    echo "$THEME" > "${themePath}"
    # Symlinks don't trigger reloads
    cp "$SRC" "${settingsPath}"
    chmod u+w,g+w "${settingsPath}"
  '';

  my-alacritty =
    let
      wrapper = ''
        #!${pkgs.runtimeShell}
        ${nixGLNvidia}/bin/nixGLNvidia ${pkgs.alacritty}/bin/alacritty "$@"
      '';
    in pkgs.runCommandLocal "alacritty" {} ''
      mkdir -p $out/bin
      echo ${strings.escapeShellArg wrapper} > $out/bin/alacritty
      chmod +x $out/bin/alacritty
      ln -sf ${pkgs.alacritty}/share $out/share
    '';
in {
  options = {
    programs.alacritty = {
      defaultSettings = mkOption {
        type = yamlFormat.type;
        default = {
          live_config_reload = true;
        };
      };
      themes.light = mkOption {
        type = types.attrs;
        default = { };
      };
      themes.dark = mkOption {
        type = types.attrs;
        default = { };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # TODO move nixGLNvidia somewhere else
      home.packages = [ nixGLNvidia toggleTheme ];
      home.activation.toggle-theme = hm.dag.entryAfter [ "writeBoundary" ]
        "$DRY_RUN_CMD ${toggleTheme}/bin/toggle-theme light";
      xsession.programs = attrsets.optionalAttrs (cfg.enable) {
        term = [ "${my-alacritty}/bin/alacritty" ];
      };
      programs.alacritty = {
        package = my-alacritty;
      };
    })
  ];
}
