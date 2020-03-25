{
  _nvim+:: {
    _plugins+:: {
      'async.vim': {
        github: 'prabirshrestha/async.vim',
        rev: 'f67ecb5a1120d0d0fb9312afcf262c829b218ca2',
      },
      'vim-lsp': {
        github: 'prabirshrestha/vim-lsp',
        rev: 'f79bf399220070123ca7642b318e5231843eb087',
      },
      'asymcomplete-lsp': {
        github: 'prabirshrestha/asyncomplete-lsp.vim',
        rev: '5c470ae8e58c8762dc4c669b38fa5649b57f53e3',
      },
    },

    _init+:: {
      'lsp.vim': |||
        let g:lsp_signs_enabled = 1
        let g:lsp_diagnostics_echo_cursor = 1
        let g:lsp_highlight_references_enabled = 1

        function! s:on_lsp_buffer_enabled() abort
          setlocal signcolumn=yes
          nmap <buffer> gd <plug>(lsp-definition)
        endfunction

        augroup lsp_install
          au!
          " call s:on_lsp_buffer_enabled only for languages that has the server registered.
          autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
        augroup END
      |||,
    },
  },
}
