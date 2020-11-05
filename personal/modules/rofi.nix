{ config, lib, pkgs, ... }:
with lib;
let
  utils = import ../nix/utils.nix { inherit lib; };
  inherit (utils) toRasi raw isRaw;
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
            theme = "Paper";
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
