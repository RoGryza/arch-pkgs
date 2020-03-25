local util = import 'lib/util.libsonnet';
local submodules = [
  import './completion.jsonnet',
  import './ctrlp.jsonnet',
  import './editing.jsonnet',
  import './lsp.jsonnet',
  import './git.jsonnet',
  import './visual.jsonnet',

  import './languages.jsonnet',
  import './python.jsonnet',
];

std.foldl(function(a, b) a + b, submodules, {
  local manifest = self,

  _depends+:: [
    'neovim',
    'neovim-drop-in',
  ],

  _programs+:: {
    editor: 'nvim',
  },

  _nvim+:: {
    _init+:: {
      'init.vim': {
        content: importstr './init.vim',
        _vimCheck:: |||
          if !get(g:, 'rogryza_loaded_init', 0)
            throw 'init.vim not loaded'
          endif
        |||,
      },
    },

    _plugins+:: {
      'vim-eunuch': {
        _version:: '1.2',
        github: 'tpope/vim-eunuch',
      },
    },
  },

  local plugins = util.mapToArray(
    function(k, v) {
      name: k,
      _version:: self.rev,
      rev: 'v%s' % self._version,
      srcdir: '%s-%s' % [std.split(self.github, '/')[1], self._version],
      _vimCheck: null,
    } + v,
    self._nvim._plugins,
  ),
  local vimChecks = std.prune(util.mapToArray(
    function(k, v) if std.isObject(v) && v._vimCheck != null then { name: k, check: v._vimCheck },
    self._nvim._init,
  )),

  source+: [
    '%(pkgname)s-%(name)s.tar.gz::https://github.com/%(github)s/archive/%(rev)s.tar.gz'
    % p { pkgname: manifest.pkgname }
    for p in plugins
  ] + [
    'test_nvim_%s' % c.name
    for c in vimChecks
  ],
  _output+:: { ['test_nvim_%s' % c.name]: c.check for c in vimChecks },

  local rtp = 'usr/share/nvim/runtime/pack/rogryza',
  _package+:: [
    'install -d $pkgdir/%s/start' % rtp,
    'install -d $pkgdir/%s/opt' % rtp,
  ] + [
    |||
      # Install vim plugin %(name)s

      pushd "${srcdir}/%(srcdir)s"
      install -d $pkgdir/%(rtp)s/start/%(name)s
      if test -n "$(find . -maxdepth 1 -name '*.vim' -print -quit)"; then
        for file in *.vim; do
          install -Dm 644 $file $pkgdir/%(rtp)s/start/%(name)s/$file
        done
      fi
      for dir in autoload colors compiler doc ftdetect ftplugin import indent keymap lang plugin print spell syntax; do
        if [ -d $dir ]; then
          cp -drr --no-preserve=ownership $dir $pkgdir/%(rtp)s/start/%(name)s/
        fi
      done
      popd
    ||| % (p { rtp: rtp })
    for p in plugins
  ],

  _files+:: util.mapPairs(
    function(path, file) [
      '%s/start/init/plugin/%s' % [rtp, path],
      if std.isString(file) then { content: file }
      else if file._vimCheck != null then file {
        check: std.join(' ', [
          'echo "Validating %s" &&',
          'XDG_CONFIG_HOME=${srcdir}/usr/share/ nvim -u NORC -i NONE --headless -c',
          "'try | source test_nvim_%s | catch | echo v:exception | cq | endtry | q'",
        ]) % [self.source, path],
      }
      else file,
    ],
    self._nvim._init,
  ),
})
