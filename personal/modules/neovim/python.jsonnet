{
  _depends+:: [
    'python-language-server',
    'python-language-server-black',
    'python-pyls-isort-git',
    'pyls-mypy',
  ],

  _nvim+:: {
    _init+:: {
      'python.vim': |||
        " Python
        augroup PythonLsp
        au!
        au User lsp_setup call lsp#register_server({
            \ 'name': 'pyls',
            \ 'cmd': {server_info->['pyls']},
            \ 'whitelist': ['python'],
            \ })
        au BufWritePre *.py LspDocumentFormatSync
        augroup END
      |||,
    },
  },
}
