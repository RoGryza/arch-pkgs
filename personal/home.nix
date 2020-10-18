let
  pkgs = import ./nix/nixpkgs.nix {};
in
  with pkgs.lib;
{
  nixpkgs.config.allowUnfree = true;
  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";

  imports = [
    ./modules/direnv
    ./modules/dunst.nix
    ./modules/neovim
    ./modules/gpg.nix
    ./modules/pass.nix
    ./modules/ssh.nix
    ./modules/tmux
    ./modules/x11
    ./modules/zsh
  ];

  home.packages = with pkgs; [
    baobab
    buku
    github-cli
    jq
    mplayer
    mupdf
    newsboat
    pavucontrol
    rtv
    slock
    # spotify
  ];

  home.keyboard.layout = "br";
  home.language.base = "en_US.UTF-8";
}
