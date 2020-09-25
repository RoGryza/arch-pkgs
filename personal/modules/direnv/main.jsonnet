local files = import 'lib/files.libsonnet';

{
  // TODO user needs to symlink direnv files
  local manifest = self,

  _depends+:: [
    'direnv',
  ],

  _direnv+:: {
    rc+: [importstr './direnvrc'],
  },

  _files+:: {
    '/usr/share/direnv/direnv': files.bash {
      content: std.lines(manifest._direnv.rc),
    },
  },

  _nvim+:: {
    _init+:: {
      'direnv.vim': |||
        function! s:direnv_init() abort
          if exists("$EXTRA_VIM")
            for path in split($EXTRA_VIM, ':')
              exec "source ".path
            endfor
          endif
        endfunction

        augroup direnv
          au!
          autocmd VimEnter * call s:direnv_init()
        augroup END
      |||,
    },
  },
}
