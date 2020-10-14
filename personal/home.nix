{ pkgs ? import ./nix/nixpkgs.nix, ... }:
with
  pkgs.lib;
{
  nixpkgs.config.allowUnfree = true;

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
    spotify
  ];

  programs.rofi.enable = true;
}
