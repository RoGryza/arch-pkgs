{
  _nvim+:: {
    _plugins+:: {
      'rust-vim': {
        github: 'rust-lang/rust.vim',
        rev: '0d8ce07aaa3b95e61bf319b25bb3b1a4ecc780c2',
      },
    },

    _ale+:: {
      _fixers+:: {
        rust: ['rustfmt'],
      },
    },
  },
}
