{ config, lib, pkgs, ... }:
with lib;
{
  options = {
    programs.passff-host.enable = mkEnableOption "passff-host";
  };

  config = {
    programs.password-store = {
      enable = true;
      settings.PASSWORD_STORE_DIR = "$HOME/.password-store";
    };
    home = optionalAttrs (config.programs.passff-host.enable) {
      packages = [ pkgs.passff-host ];
      file.".mozilla/native-messaging-hosts/passff.json".source =
        "${pkgs.passff-host}/share/passff-host/passff.json";
    };
  };
}
