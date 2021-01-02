{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.alacritty;
  # TODO use an overlay...
  sources = import ../../nix/sources.nix;
  # TODO expose config option to pick nixGL wrapper
  nixGLNvidia = (import sources.nixGL { inherit pkgs; }).nixGLNvidia;
  yamlFormat = pkgs.formats.yaml { };

  settingsPath = "${config.xdg.configHome}/alacritty/alacritty.yml";

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

  schemeYamlTemplate = {
    # Source: https://github.com/aaron-williamson/base16-alacritty/blob/master/templates/default-256.mustache
    colors = {
      primary.background = "0x{{base00-hex}}";
      primary.foreground = "0x{{base05-hex}}";

      cursor.text = "0x{{base00-hex}}";
      cursor.cursor = "0x{{base05-hex}}";

      # Normal colors
      normal.black = "0x{{base00-hex}}";
      normal.red = "0x{{base08-hex}}";
      normal.green = "0x{{base0B-hex}}";
      normal.yellow = "0x{{base0A-hex}}";
      normal.blue = "0x{{base0D-hex}}";
      normal.magenta = "0x{{base0E-hex}}";
      normal.cyan = "0x{{base0C-hex}}";
      normal.white = "0x{{base05-hex}}";

      # Bright colors
      bright.black = "0x{{base03-hex}}";
      bright.red = "0x{{base08-hex}}";
      bright.green = "0x{{base0B-hex}}";
      bright.yellow = "0x{{base0A-hex}}";
      bright.blue = "0x{{base0D-hex}}";
      bright.magenta = "0x{{base0E-hex}}";
      bright.cyan = "0x{{base0C-hex}}";
      bright.white = "0x{{base07-hex}}";

      indexed_colors = [
        { index = 16; color = "0x{{base09-hex}}"; }
        { index = 17; color = "0x{{base0F-hex}}"; }
        { index = 18; color = "0x{{base01-hex}}"; }
        { index = 19; color = "0x{{base02-hex}}"; }
        { index = 20; color = "0x{{base04-hex}}"; }
        { index = 21; color = "0x{{base06-hex}}"; }
      ];
    };
  };

  alacrittyConfigs = config.lib.base16.templates {
    app = "alacritty";
    template = yamlFormat.generate "alacritty-base16-template"
      (cfg.defaultSettings // schemeYamlTemplate);
    install = name: package: ''ln -s ${package} $out/${name}.yaml'';
    installPhase = ''mkdir -p $out'';
  };
in {
  options = {
    programs.alacritty = {
      defaultSettings = mkOption {
        type = yamlFormat.type;
        default = {
          live_config_reload = true;
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # TODO move nixGLNvidia somewhere else
      home.packages = [ nixGLNvidia ];
      xsession.programs.term = [ "${my-alacritty}/bin/alacritty" ];
      programs.alacritty = {
        package = my-alacritty;
      };

      me.themes.hooks.alacritty = ''
        # Symlinks don't trigger reloads
        cp "${alacrittyConfigs}/$1.yaml" "${settingsPath}"
        chmod u+w,g+w "${settingsPath}"
      '';
    })
  ];
}
