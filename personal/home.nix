{ pkgs ? import ./nix/nixpkgs.nix, ... }:
with
  pkgs.lib;
{
  imports = [
    ./modules/direnv
    ./modules/gpg.nix
    ./modules/ssh.nix
    ./modules/tmux
    ./modules/zsh
  ];

  home.packages = with pkgs; [
    buku
  ];
}
