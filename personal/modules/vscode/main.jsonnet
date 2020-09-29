local files = import 'lib/files.libsonnet';
{
  // TODO manage plugins
  _depends+:: ['code'],

  _files+:: {
    'usr/bin/vscode-nvim': files.bash {
      executable: true,
      content: |||
        #!/bin/bash
        nvim --noplugin "$@"
      |||,
    },
    'usr/share/nvim/vscode.vim': {
      content: |||
        filetype plugin indent on
        syntax on

        let mapleader=","

        set ts=2
        set sw=2
        set softtabstop=2
        set expandtab

        set copyindent
        set smartindent

        set formatoptions+=t
        set splitbelow
        set splitright
        set wildmenu
        set wildmode=longest,list
        set noshowmode
        set hidden
        set ignorecase
        set smartcase

        " Use system clipboard
        set clipboard=unnamed

        " Persist (g)undo tree between sessions
        set undofile
        set history=4096
        set undolevels=4096

        set colorcolumn=100
        highlight ColorColumn ctermbg=darkgray

        set scrolloff=10

        " Keep search results at the center of the screen
        nmap n nzz
        nmap N Nzz
        nmap * *zz
        nmap # #zz
        nmap g* g*zz
        nmap g# g#zz

        nnoremap j gj
        nnoremap k gk

        nnoremap <Leader>e :bn<CR>
        nnoremap <Leader>q :bp<CR>
        nnoremap <Leader>bd :silent! bp<bar>sp<bar>silent! bn<bar>bd<CR>
        nnoremap <Leader>w :w<CR>

        nnoremap <Leader><space> :nohlsearch<CR>

        nnoremap <space> za
      |||,
    },
  },
}
