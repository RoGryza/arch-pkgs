{
  _depends+:: [
    'mypy',
    'python-black',
    'python-isort',
    'python-jedi',
    'python-pylint',
  ],

  _nvim+:: {
    _plugins+:: {
      'deoplete-jedi': {
        github: 'deoplete-plugins/deoplete-jedi',
        rev: '3d5d8c9f13f123bdd80f6ffd68fed7b4e4c35053',
      },
    },

    _ale+:: {
      _fixers+:: {
        python: ['black', 'isort'],
      },
      _linters+:: {
        python: ['mypy', 'pylint'],
      },
    },
  },
}
