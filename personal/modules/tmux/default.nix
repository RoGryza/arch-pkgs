{ config, pkgs, ... }:
let
  cfg = config.programs.tmux;
in
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

  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.vim-tmux-navigator;
      config = ''
      let g:tmux_navigator_no_mappings = 1
      nnoremap <silent> <C-w>h :TmuxNavigateLeft<cr>
      nnoremap <silent> <C-w>j :TmuxNavigateDown<cr>
      nnoremap <silent> <C-w>k :TmuxNavigateUp<cr>
      nnoremap <silent> <C-w>l :TmuxNavigateRight<cr>
      '';
    }
  ];
}
