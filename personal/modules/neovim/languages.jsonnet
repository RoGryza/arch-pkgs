{
  _nvim+:: {
    _plugins+:: {
      'vim-jsonnet': {
        github: 'google/vim-jsonnet',
        rev: 'b7459b36e5465515f7cf81d0bb0e66e42a7c2eb5',
      },
      'vim-javascript': {
        github: 'pangloss/vim-javascript',
        _version:: '1.2.2',
      },
      'vim-svelte': {  // depends on vim-javascript!
        github: 'evanleck/vim-svelte',
        rev: '721d5adb8e05e8da49f0cbdde00c51cf4bcbf4f5',
      },
    },
  },
}
