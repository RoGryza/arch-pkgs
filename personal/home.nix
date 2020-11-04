{ pkgs, ... }:
let
  sources = import ./nix/sources.nix;
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
    ./modules/rofi.nix
    ./modules/ssh.nix
    ./modules/tmux
    ./modules/x11
    ./modules/zsh
  ];

  home.packages = with pkgs; [
    baobab
    bat
    buku
    fasd
    fd
    github-cli
    jq
    lsd
    mplayer
    mupdf
    newsboat
    pavucontrol
    ripgrep
    rtv
    spotify
  ];

  home.language.base = "en_US.UTF-8";
  targets.genericLinux = {
    enable = true;
    extraXdgDataDirs = [ "/usr/share" "/usr/local/share/" ];
  };
  programs.rofi.enable = true;
}
