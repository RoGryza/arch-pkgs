{
  _nvim+:: {
    _plugins+:: {
      dracula: {
        github: 'dracula/vim',
        _version: '2.0.0',
      },
    },
    _init+:: {
      'visual.vim': |||
        " Visual
        set background=dark
        colorscheme dracula
      |||,
    },
  },
}
