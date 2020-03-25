{
  _nvim+:: {
    _plugins+:: {
      'asyncomplete.vim': {
        github: 'prabirshrestha/asyncomplete.vim',
        _version: '2.0.0',
      },
    },

    _init+:: {
      'completion.vim': |||
        " Use tab/enter for completion suggestions
        inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
        inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
      |||,
    },
  },
}
