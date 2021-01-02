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
    bat
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
    # papercolor schemes by jonleopard: https://github.com/jonleopard
    schemes.light = {
      base00 = "eeeeee";
      base01 = "af0000";
      base02 = "008700";
      base03 = "5f8700";
      base04 = "0087af";
      base05 = "444444";
      base06 = "005f87";
      base07 = "878787";
      base08 = "bcbcbc";
      base09 = "d70000";
      base0A = "d70087";
      base0B = "8700af";
      base0C = "d75f00";
      base0D = "d75f00";
      base0E = "005faf";
      base0F = "005f87";
    };
    schemes.dark = {
      base00 = "1c1c1c";
      base01 = "af005f";
      base02 = "5faf00";
      base03 = "d7af5f";
      base04 = "5fafd7";
      base05 = "808080";
      base06 = "d7875f";
      base07 = "d0d0d0";
      base08 = "585858";
      base09 = "5faf5f";
      base0A = "afd700";
      base0B = "af87d7";
      base0C = "ffaf00";
      base0D = "ff5faf";
      base0E = "00afaf";
      base0F = "5f8787";
    };
  };
}
