{
  _depends+:: [
    'python-language-server',
    'python-language-server-black',
    'python-pyls-isort-git',
    'pyls-mypy',
  ],

  _viminit+:: |||
    " Python
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
  |||,
}
