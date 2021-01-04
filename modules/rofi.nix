{ config, lib, pkgs, ... }:
with lib;
let
  utils = import ../nix/utils.nix { inherit lib; };
  inherit (utils) toRasi raw isRaw;
  themesCfg = config.me.themes;
  cfg = config.programs.rofi;

  themeTemplate = {
    # Original template by 0xdec: https://github.com/0xdec/base16-rofi
  "*" = {
    red = raw "rgba ( {{base08-rgb-r}}, {{base08-rgb-g}}, {{base08-rgb-b}}, 100 % )";
    blue = raw "rgba ( {{base0D-rgb-r}}, {{base0D-rgb-g}}, {{base0D-rgb-b}}, 100 % )";
    lightfg = raw "rgba ( {{base06-rgb-r}}, {{base06-rgb-g}}, {{base06-rgb-b}}, 100 % )";
    lightbg = raw "rgba ( {{base01-rgb-r}}, {{base01-rgb-g}}, {{base01-rgb-b}}, 100 % )";
    foreground = raw "rgba ( {{base05-rgb-r}}, {{base05-rgb-g}}, {{base05-rgb-b}}, 100 % )";
    background = raw "rgba ( {{base00-rgb-r}}, {{base00-rgb-g}}, {{base00-rgb-b}}, 100 % )";
    background-color = raw "rgba ( {{base00-rgb-r}}, {{base00-rgb-g}}, {{base00-rgb-b}}, 0 % )";
    separatorcolor = raw "@foreground";
    border-color = raw "@foreground";
    selected-normal-foreground = raw "@lightbg";
    selected-normal-background = raw "@lightfg";
    selected-active-foreground = raw "@background";
    selected-active-background = raw "@blue";
    selected-urgent-foreground = raw "@background";
    selected-urgent-background = raw "@red";
    normal-foreground = raw "@foreground";
    normal-background = raw "@background";
    active-foreground = raw "@blue";
    active-background = raw "@background";
    urgent-foreground = raw "@red";
    urgent-background = raw "@background";
    alternate-normal-foreground = raw "@foreground";
    alternate-normal-background = raw "@lightbg";
    alternate-active-foreground = raw "@blue";
    alternate-active-background = raw "@lightbg";
    alternate-urgent-foreground = raw "@red";
    alternate-urgent-background = raw "@lightbg";
    spacing = 2;
  };
  window = {
    background-color = raw "@background";
    border = 1;
    padding = 5;
  };
  mainbox = {
    border = 0;
    padding = 0;
  };
  message = {
    border = raw "1px dash 0px 0px";
    border-color = raw "@separatorcolor";
    padding = raw "1px";
  };
  textbox = {
    text-color = raw "@foreground";
  };
  listview = {
    fixed-height = 0;
    border = raw "2px dash 0px 0px";
    border-color = raw "@separatorcolor";
    spacing = raw "2px";
    scrollbar = true;
    padding = raw "2px 0px 0px";
  };
  element = {
    border = 0;
    padding = raw "1px";
  };
  "element normal.normal" = {
    background-color = raw "@normal-background";
    text-color = raw "@normal-foreground";
  };
  "element normal.urgent" = {
    background-color = raw "@urgent-background";
    text-color = raw "@urgent-foreground";
  };
  "element normal.active" = {
    background-color = raw "@active-background";
    text-color = raw "@active-foreground";
  };
  "element selected.normal" = {
    background-color = raw "@selected-normal-background";
    text-color = raw "@selected-normal-foreground";
  };
  "element selected.urgent" = {
    background-color = raw "@selected-urgent-background";
    text-color = raw "@selected-urgent-foreground";
  };
  "element selected.active" = {
    background-color = raw "@selected-active-background";
    text-color = raw "@selected-active-foreground";
  };
  "element alternate.normal" = {
    background-color = raw "@alternate-normal-background";
    text-color = raw "@alternate-normal-foreground";
  };
  "element alternate.urgent" = {
    background-color = raw "@alternate-urgent-background";
    text-color = raw "@alternate-urgent-foreground";
  };
  "element alternate.active" = {
    background-color = raw "@alternate-active-background";
    text-color = raw "@alternate-active-foreground";
  };
  scrollbar = {
    width = raw "4px";
    border = 0;
    handle-color = raw "@normal-foreground";
    handle-width = raw "8px";
    padding = 0;
  };
  sidebar = {
    border = raw "2px dash 0px 0px";
    border-color = raw "@separatorcolor";
  };
  button = {
    spacing = 0;
    text-color = raw "@normal-foreground";
  };
  "button selected" = {
    background-color = raw "@selected-normal-background";
    text-color = raw "@selected-normal-foreground";
  };
  inputbar = {
    spacing = raw "0px";
    text-color = raw "@normal-foreground";
    padding = raw "1px";
    children = [ "prompt" "textbox-prompt-colon" "entry" "case-indicator" ];
  };
  case-indicator = {
    spacing = 0;
    text-color = raw "@normal-foreground";
  };
  entry = {
    spacing = 0;
    text-color = raw "@normal-foreground";
  };
  prompt = {
    spacing = 0;
    text-color = raw "@normal-foreground";
  };
  textbox-prompt-colon = {
    expand = false;
    str = ":";
    margin = raw "0px 0.3000em 0.0000em 0.0000em";
    text-color = raw "inherit";
  };
};
rofiThemes = config.lib.base16.templates {
  app = "rofi";
  template = pkgs.writeText "rofi-base16-template" (toRasi themeTemplate);
  installPhase = ''mkdir -p $out'';
  install = name: package: ''ln -s ${package} $out/base16-${name}.rasi'';
};
in {
  options.programs.rofi = {
    pkg = mkOption {
      type = types.package;
      default = pkgs.rofi;
    };

    # TODO proper config type
    config =
      with types;
      let
        scalars = oneOf [ str float int bool utils.types.raw ];
        sectionType = attrsOf (either scalars (listOf scalars));
      in
      mkOption {
        type = types.attrsOf sectionType;
        default = {
          configuration = {
            drun-display-format = "{icon} {name}";
            display-drun = "Apps";
            show-icons = true;
            terminal = config.xsession.programs.term;
            sidebar-mode = false;
          };

          "*" = {
            font = "DejaVu Sans Mono 32";
          };

          window = {
            height = raw "75%";
            width = raw "75%";
          };
        };
      };
  };

  config = {
    xsession.programs.launcher = mkIf (cfg.enable)
      # TODO check why it's pulling the wrong font from Xresources
      [
        "${cfg.pkg}/bin/rofi"
        "-modi" "drun"
        "-show" "drun"
        "-drun-show-actions"
        "-font" cfg.config."*".font
      ];

    xdg.configFile = attrsets.optionalAttrs (cfg.enable) {
      "rofi/default-config.rasi" = {
        text = ''
          ${toRasi { inherit (cfg.config) configuration; }}
          ${toRasi (attrsets.filterAttrs (n: _: n != "configuration") cfg.config)}
        '';
      };
      "rofi/themes".source = rofiThemes;
    };

    me.themes.hooks.rofi = ''
      echo '@import "default-config"' > "$XDG_CONFIG_HOME/rofi/config.rasi"
      echo '@theme "base16-'$1'"' >> "$XDG_CONFIG_HOME/rofi/config.rasi"
    '';
    # TODO add rofi theme-switcher
  };
}
