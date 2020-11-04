{ config, lib, pkgs, ... }:
with lib;
let
  inherit (import ../nix/utils.nix { inherit lib; }) toRasi raw isRaw;
  cfg = config.programs.rofi;
in
{
  options.programs.rofi = {
    pkg = mkOption {
      type = types.package;
      default = pkgs.rofi;
    };

    config =
      with types;
      let
        rawType = mkOptionType {
          name = "raw";
          check = x: builtins.trace (builtins.typeOf x) (isRaw x);
        };
        scalars = oneOf [ str float int bool rawType ];
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
            fullscreen = true;
            sidebar-mode = false;
            xoffset = 0;
            bw = 0;
          };

          "*" = {
            background-color = raw "#00000000";
            font = "DejaVu Sans Mono 48";
            bg = raw "#00000099";
            find = raw "#00000099";
            txt = raw "#e5e5e5";
            border = raw "#e5e5e5";
            bg-sel = raw "#00000099";
            fg = raw "#ffffff";
          };

          window = {
            width = raw "100%";
            height = raw "100%";
            transparency = "real";
          };

          mainbox = {
            children = map raw [ "inputbar" "listview" ];
            padding = raw "0% 5% 5% 5%";
            background-color = raw "@bg";
            border = 0;
            border-radius = 0;
            border-color = raw "@border";
          };

          listview = {
            columns = 7;
            padding = raw "1%";
            spacing = raw "5%";
          };

          element = {
            border = 0;
            border-radius = 0;
            text-color = raw "@fg";
            orientation = raw "vertical";
            padding = raw "2% 2% 2% 2%";
          };

          "element selected" = {
            background-color = raw "@bg-sel";
            border = raw "0 0 2 0";
            border-radius = 0;
            border-color = raw "@border";
            text-color = raw "@fg";
          };

          inputbar = {
            children = [ raw "entry" ];
            padding = raw "4 4 4 4";
            margin = raw "8% 30%";
            background-color = raw "@find";
            border = raw "0 0 1 0";
            border-radius = 0;
            border-color = raw "@border";
          };

          prompt = {
            enabled = false;
          };

          entry = {
            font = "DejaVu Sans Mono 12";
            text-color = raw "@txt";
            padding = raw "8 12 8 12";
          };
        };
      };
  };

  config = {
    xsession.programs.launcher = mkIf (cfg.enable)
      "${cfg.pkg}/bin/rofi -modi drun -show drun -drun-show-actions";

    home.file = attrsets.optionalAttrs (cfg.enable) {
      "${config.xdg.configHome}/rofi/config.rasi" = {
        text = ''
          ${toRasi { inherit (cfg.config) configuration; }}

          ${toRasi (attrsets.filterAttrs (n: _: n != "configuration") cfg.config)}
        '';
      };
    };
  };
}
