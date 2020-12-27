# TODO use wired-notify from overlays
{ config, lib, pkgs, ...  }:
with lib;
let
  sources = import ../../../nix/sources.nix;
  cfg = config.services.wired-notify;
  wired-notify = pkgs.rustPlatform.buildRustPackage rec {
    pname = "wired-notify";
    version = "0.8.0";

    buildInputs = with pkgs; [ cairo dbus glib pango pkg-config x11 ];

    src = sources.wired-notify;
    cargoSha256 = "08z7q41vg9409pia72nla0qiim9wy397nvgyc1idksfkqs96w95y";
    cargoPatches = [ ./wired-notify.patch ];

    RUST_BACKTRACE=1;
  };
in
{
  options = {
    services.wired-notify = {
      enable = mkEnableOption "enable";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ wired-notify ];
    })
  ];
}
