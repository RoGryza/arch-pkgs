local util = import 'lib/util.libsonnet';
{
  _nvim+:: {
    local nvim = self,

    _plugins+:: {
      ale: {
        github: 'dense-analysis/ale',
        _version: '2.6.0',
        _systemDepends: ['python-msgpack'],
        _extraPluginDirs: ['ale_linters'],
      },
      deoplete: {
        github: 'Shougo/deoplete.nvim',
        rev: '5.2',
      },
    },

    _ale+:: {
      _linters+:: {
      },
      _fixers+:: {
      },
    },

    _deoplete:: {
      _sources+:: {
        _+: ['ale'],
      },
    },

    _init+:: {
      'language_support.vim': |||
        let g:deoplete#enable_at_startup = 1
        let g:ale_completion_enabled = 1
        let g:ale_fix_on_save = 1
        call deoplete#custom#option('sources', %(sources)s)
        let g:ale_linters = %(linters)s
        let g:ale_fixers = %(fixers)s
      ||| % {
        sources: util.formatVim(nvim._deoplete._sources),
        linters: util.formatVim(nvim._ale._linters),
        fixers: util.formatVim(nvim._ale._fixers),
      },
    },
  },
}
