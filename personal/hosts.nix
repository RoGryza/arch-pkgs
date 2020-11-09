{
  rogryza = { pkgs, ... }: {
    imports = [ ./home.nix ];

    home.keyboard.layout = "br";
    services.gpg-agent.sshKeys = [ "8D9342B7F994DE2B879A03F4CF270B470301BE9C" ];
    programs.scrot.enable = true;
    programs.passff-host.enable = true;
    programs.tridactyl.enable = true;
  };
  rogryza-tl = { pkgs, ... }: {
    imports = [ ./home.nix ];
    home.packages = with pkgs; [ rustup slack ];
    xsession.programs.browser = [ "/usr/bin/google-chrome-stable" ];
    services.gpg-agent.sshKeys = [
      "6199884D574FA800EE6D72D4F151EBBC6B3B8192"
      "71014621DE5C3BFFE7C014193FE1FA377AE40438"
    ];
  };
}
