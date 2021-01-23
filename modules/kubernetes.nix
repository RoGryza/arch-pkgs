{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.me.kubernetes;
in {
  options = {
    me.kubernetes = {
      enable = mkEnableOption "Enable kubernetes";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = with pkgs; [ kubectl stern ];
    })
  ];
}
