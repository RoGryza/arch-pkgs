{ config, lib, ... }:
with lib;
let
  inherit (config.xsession) notificationDaemon;
in
{
  imports = [ ./dunst.nix ./wired-notify.nix ];

  options = {
    xsession.notificationDaemon = mkOption {
      type = types.enum [ "dunst" "wired-notify" ];
      default = "dunst";
    };
  };

  config = {
    services.dunst.enable = notificationDaemon == "dunst";
    services.wired-notify.enable = notificationDaemon == "wired-notify";
  };
}
