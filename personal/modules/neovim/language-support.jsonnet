local util = import 'lib/util.libsonnet';
{
  _nvim+:: {
    local nvim = self,

    _plugins+:: {
      ale: {
        github: 'dense-analysis/ale',
        _version: '2.6.0',
        _systemDepends: ['python-msgpack'],
        _extraDirs: ['ale_linters'],
      },
      'coc.nvim': {
        github: 'neoclide/coc.nvim',
        _version: '0.0.79',
        _systemDepends: ['nodejs', 'yarn'],
        _extraFiles: ['package.json'],
        _extraDirs: ['bin', 'build', 'data'],
        _beforePackage: |||
          rm bin/server.js
          nvim -es --cmd ":helptags doc" --cmd ":q"
        |||,
      },
    },

    _ale+:: {
      _linters+:: {
      },
      _fixers+:: {
      },
    },

    _init+:: {
      'language_support.vim': |||
        let g:ale_completion_enabled = 1
        let g:ale_disable_lsp = 1
        let g:ale_fix_on_save = 1
        let g:ale_linters = %(linters)s
        let g:ale_fixers = %(fixers)s
      ||| % {
        linters: util.formatVim(nvim._ale._linters),
        fixers: util.formatVim(nvim._ale._fixers),
      },
      'coc.vim': importstr './coc.vim',
    },
  },
}
