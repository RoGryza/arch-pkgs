{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.scrot;
in
{
  options = {
    programs.scrot.enable = mkEnableOption "scrot";
  };

  config = {
    home.packages =
      let
        scrot-xclip = pkgs.writeScriptBin "scrot-xclip" ''
        #!${pkgs.bash}/bin/bash

        set -euo pipefail

        SS="$(mktemp --suffix=".png")"
        function cleanup {
          rm -f "$SS"
        }
        trap cleanup EXIT

        ${pkgs.scrot}/bin/scrot --select --overwrite "$SS"
        ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i < "$SS"
        '';
      in
      optionals (cfg.enable)
        [
          scrot-xclip
          (pkgs.scrot.overrideAttrs
            (old: {
              buildPhase = ''
              ${strings.optionalString (builtins.hasAttr "buildPhase" old) old.buildPhase}

              mkdir -p $out/share/applications
              echo ${strings.escapeShellArg (builtins.readFile ./scrot.desktop)} > $out/share/applications/scrot.desktop
              '';
            })
          )
        ];
  };
}
