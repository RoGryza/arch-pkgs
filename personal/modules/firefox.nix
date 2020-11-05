{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.tridactyl;
in
{
  options = {
    programs.tridactyl.enable = mkEnableOption "enable";
  };

  config = {
    home.packages = optional (cfg.enable) pkgs.tridactyl-native;
  };
}
