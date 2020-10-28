{
  rogryza = {
    imports = [ ./home.nix ];
    home.keyboard.layout = "br";
    services.gpg-agent.sshKeys = [ "8D9342B7F994DE2B879A03F4CF270B470301BE9C" ];
  };
  rogryza-tl = { pkgs, ... }: {
    imports = [ ./home.nix ];
    home.packages = with pkgs; [ slack ];
    services.gpg-agent.sshKeys = [ "71014621DE5C3BFFE7C014193FE1FA377AE40438" ];
  };
}
