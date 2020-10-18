{ config, pkgs, lib, ... }:
with lib;
let
  my-ale = {
    plugin = pkgs.vimPlugins.ale;
    config = ''
    let g:ale_completion_enabled = 1
    let g:ale_disable_lsp = 1
    let g:ale_fix_on_save = 1
    '';
  };
  my-lsc = {
      plugin = pkgs.vimPlugins.vim-lsc;
      config = ''
      let g:lsc_auto_map = v:true
      let g:lsc_enable_autocomplete = v:true
      let g:lsc_enable_diagnostics = v:false
      let g:lsc_trace_level = 'off'
      autocmd CompleteDone * silent! pclose
      let g:lsc_server_commands = {
        ${strings.concatStringsSep ",\n" (attrsets.mapAttrsToList
          (k: v: ''
          \  '${k}': {
          \    'command': '${v}',
          \    'log_level': -1,
          \    'suppress_stderr': v:true,
          \  }'')
          config.programs.neovim.lsc.serverCommands
        )}
      \}
      '';
  };
  my-dracula = {
    plugin = pkgs.vimPlugins.dracula-vim;
    config = ''
    set background=dark
    augroup dracula
      au!
      autocmd VimEnter * colorscheme dracula
    augroup END
    '';
  };
  my-ctrlp = {
    plugin = pkgs.vimPlugins.ctrlp;
    config = ''
    let g:ctrlp_open_new_file = 'r'
    let g:ctrlp_switch_buffer = 0

    let g:ctrlp_custom_ignore = {
      \ 'dir':  'node_modules\|__pycache__',
      \ 'file': '\v\.pyc$',
      \ }

    let g:ctrlp_map = '<c-p>'
    nnoremap <C-P> :CtrlP .<CR>
    nnoremap <C-B> :CtrlPBuffer<CR>
    nnoremap <C-T> :CtrlPTag<CR>
    '';
  };
in
{
  options = {
    programs.neovim.lsc.serverCommands = mkOption {
      type = types.attrsOf types.string;
      default = {};
    };
  };

  imports = [ ./languages.nix ];

  config = {
    home.packages = [ pkgs.neovim-qt ];

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraConfig = builtins.readFile ./init.vim;
      plugins = with pkgs.vimPlugins; [
        my-ale
        my-ctrlp
        my-dracula
        my-lsc
        vim-commentary
        vim-eunuch
        vim-fugitive
        vim-gitgutter
        vim-repeat
        vim-surround
      ];
    };
  };
}
