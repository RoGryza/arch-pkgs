{ pkgs, ... }:
let
  sources = import ./nix/sources.nix;
in
  with pkgs.lib;
{
  nixpkgs.config.allowUnfree = true;
  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";

  imports = [
    ./modules/bat
    ./modules/direnv
    ./modules/firefox.nix
    ./modules/neovim
    ./modules/gpg.nix
    ./modules/pass.nix
    ./modules/rofi.nix
    ./modules/ssh.nix
    ./modules/themes
    ./modules/tmux
    ./modules/x11
    ./modules/zsh
  ];

  home.packages = with pkgs; [
    baobab
    buku
    fasd
    fd
    github-cli
    jq
    lsd
    manix
    mplayer
    mupdf
    newsboat
    nixFlakes
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

  me.themes = {
    enable = true;
    defaultScheme = "light";
    # papercolor schemes by Chris Kempson: https://github.com/chriskempson/base16-default-schemes
    schemes.light = {
      base00 = "f8f8f8";
      base01 = "e8e8e8";
      base02 = "d8d8d8";
      base03 = "b8b8b8";
      base04 = "585858";
      base05 = "383838";
      base06 = "282828";
      base07 = "181818";
      base08 = "ab4642";
      base09 = "dc9656";
      base0A = "f7ca88";
      base0B = "a1b56c";
      base0C = "86c1b9";
      base0D = "7cafc2";
      base0E = "ba8baf";
      base0F = "a16946";
    };
    schemes.dark = {
      base00 = "181818";
      base01 = "282828";
      base02 = "383838";
      base03 = "585858";
      base04 = "b8b8b8";
      base05 = "d8d8d8";
      base06 = "e8e8e8";
      base07 = "f8f8f8";
      base08 = "ab4642";
      base09 = "dc9656";
      base0A = "f7ca88";
      base0B = "a1b56c";
      base0C = "86c1b9";
      base0D = "7cafc2";
      base0E = "ba8baf";
      base0F = "a16946";
    };
  };
}
