{
  _depends+:: ['vim-lsp-git'],

  _viminit+:: |||
    " LSP
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
}
