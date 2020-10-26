{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    aggressiveResize = true;
    #vi-like keybindings
    customPaneNavigationAndResize = true;
    keyMode = "vi";
    escapeTime = 0;
    shortcut = "a";
    terminal = "tmux-256color";

    extraConfig = builtins.readFile ./tmux.conf;

    plugins = [ pkgs.tmuxPlugins.sessionist ];
  };
}
