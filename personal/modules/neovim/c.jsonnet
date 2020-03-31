{
  _depends+:: [
    'clang',
  ],

  _nvim+:: {
    _ale+:: {
      _fixers+:: {
        c: ['clang-format'],
      },
      _linters+:: {
        c: ['clang'],
      },
    },
  },
}
