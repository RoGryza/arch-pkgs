{ config, ... }:
let
  cfg = config.services.gpg-agent;
in
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport =
      cfg.sshKeys != null &&
      (builtins.length cfg.sshKeys) > 0;
    pinentryFlavor = "qt";
  };
}
