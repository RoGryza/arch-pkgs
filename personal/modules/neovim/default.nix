{ config, pkgs, lib, ... }:
with lib;
let
  my-plugins = [
    {
      plugin = pkgs.vimPlugins.ale;
      config = ''
      let g:ale_completion_enabled = 1
      let g:ale_disable_lsp = 1
      let g:ale_fix_on_save = 1
      '';
    }
    {
      plugin = pkgs.vimPlugins.deoplete-nvim;
      config = ''
      let g:deoplete#enable_at_startup = 1

      inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()
      inoremap <silent><expr> <S-TAB>
      \ pumvisible() ? "\<C-p>" :
      \ <SID>check_back_space() ? "\<S-TAB>" :
      \ deoplete#manual_complete()
      function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
      endfunction
      '';
    }
    {
        plugin = pkgs.vimPlugins.vim-lsc;
        config = ''
        let g:lsc_enable_autocomplete = v:true
        let g:lsc_enable_diagnostics = v:false
        let g:lsc_trace_level = 'off'
        autocmd CompleteDone * silent! pclose
        let g:lsc_auto_map = {
        \  'defaults': v:true,
        \  'PreviousReference': ${"''"},
        \}
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
    }
    {
      plugin = pkgs.vimPlugins.papercolor-theme;
      config = ''
      set background=light
      augroup theme
        au!
        autocmd VimEnter * colorscheme PaperColor
      augroup END
      '';
    }
    {
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
    }
  ];
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
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraConfig = builtins.readFile ./init.vim;
      plugins = with pkgs.vimPlugins; [
        # TODO figure out why overlays aren't working
        (pkgs.vimUtils.buildVimPlugin {
          pname = "deoplete-vim-lsc";
          src = (import ../../nix/sources.nix).deoplete-vim-lsc;
          version = "0";
        })
        vim-commentary
        vim-eunuch
        vim-fugitive
        vim-gitgutter
        vim-repeat
        vim-surround
      ] ++ my-plugins;
    };
  };
}
