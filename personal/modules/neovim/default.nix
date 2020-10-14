{ pkgs, lib, ... }:
let
  my-ale = {
    plugin = pkgs.vimPlugins.ale;
    config = ''
    let g:ale_completion_enabled = 1
    let g:ale_disable_lsp = 1
    let g:ale_fix_on_save = 1
    '';
  };
  my-dracula = {
    plugin = pkgs.vimPlugins.dracula-vim;
    config = lib.mkAfter ''
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
  home.packages = [ pkgs.neovim-qt ];

  imports = [ ./languages.nix ];

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
      vim-commentary
      vim-eunuch
      vim-fugitive
      vim-gitgutter
      vim-repeat
      vim-surround
    ];
  };
}
