{
  _depends+:: [
    'typescript',  // for tsuquyomi
  ],

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
      'vim-nix': {
        github: 'LnL7/vim-nix',
        rev: 'd733cb96707a2a6bdc6102b6d89f947688e0e959',
      },
      'vim-svelte': {  // depends on vim-javascript!
        github: 'evanleck/vim-svelte',
        rev: '721d5adb8e05e8da49f0cbdde00c51cf4bcbf4f5',
      },
      'vim-typescript': {
        github: 'leafgarland/typescript-vim',
        rev: '17d85d8051ba21283e62a9101734981e10b732fd',
      },
      tsuquyomi: {
        github: 'quramy/tsuquyomi',
        _version: '0.8.0',
      },
    },
  },
}
