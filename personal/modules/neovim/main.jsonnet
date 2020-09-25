local util = import 'lib/util.libsonnet';
local submodules = [
  import './ctrlp.jsonnet',
  import './editing.jsonnet',
  import './language-support.jsonnet',
  import './lsp.jsonnet',
  import './git.jsonnet',
  import './visual.jsonnet',

  import './languages.jsonnet',
  import './c.jsonnet',
  import './python.jsonnet',
  import './rust.jsonnet',
];

std.foldl(function(a, b) a + b, submodules, {
  local manifest = self,

  local plugins = util.mapToArray(
    function(k, v) {
      name: k,
      _version:: self.rev,
      rev: 'v%s' % self._version,
      srcdir: '%s-%s' % [std.split(self.github, '/')[1], self._version],
      _vimCheck: null,
      _systemDepends: [],
      _extraFiles: [],
      _extraPluginDirs: [],
    } + v,
    self._nvim._plugins,
  ),

  _depends+:: [
    'neovim',
    'neovim-drop-in',
    'python-pynvim',
    'neovim-qt',
  ] + std.flattenArrays([p._systemDepends for p in plugins]),

  _programs+:: {
    editor: 'nvim',
  },

  _nvim+:: {
    _init+:: {
      'init.vim': {
        content: importstr './init.vim',
        // _vimCheck:: |||
        //   if !get(g:, 'rogryza_loaded_init', 0)
        //     throw 'init.vim not loaded'
        //   endif
        // |||,
      },
    },

    _plugins+:: {
      'vim-eunuch': {
        _version:: '1.2',
        github: 'tpope/vim-eunuch',
      },
    },

    _plugindirs+:: [
      'autoload',
      'colors',
      'compiler',
      'doc',
      'ftdetect',
      'ftplugin',
      'import',
      'indent',
      'keymap',
      'lang',
      'plugin',
      'print',
      'rplugin',
      'spell',
      'syntax',
    ],
  },

  local vimChecks = std.prune(util.mapToArray(
    function(k, v) if std.isObject(v) && std.objectHasAll(v, '_vimCheck') && v._vimCheck != null then { name: k, check: v._vimCheck },
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
      for dir in %(plugindirs)s; do
        if [ -d $dir ]; then
          cp -drr --no-preserve=ownership $dir $pkgdir/%(rtp)s/start/%(name)s/
        fi
      done
      %(extraFiles)s
      popd
    ||| % (p {
             plugindirs: std.join(' ', manifest._nvim._plugindirs + p._extraPluginDirs),
             rtp: rtp,
             extraFiles: std.join('\n', [
               'install -Dm 644 %(file)s $pkgdir/%(rtp)s/start/%(name)s/%(file)s' % (self { file: f })
               for f in p._extraFiles
             ]),
           })
    for p in plugins
  ],

  local toInitFiles = function(d, files)
    util.mapPairs(
      function(path, file) [
        '%s/%s' % [d, path],
        if std.isString(file) then { content: file }
        else if std.objectHasAll(file, '_vimCheck') && file._vimCheck != null then file {
          check: std.join(' ', [
            'echo "Validating %s" &&',
            'XDG_CONFIG_HOME=${srcdir} nvim -u NORC -i NONE --headless -c',
            "'try | source test_nvim_%s | catch | echo v:exception | cq | endtry | q'",
          ]) % [self.source, path],
        }
        else file,
      ],
      files,
    ),

  _files+:: toInitFiles('%s/start/init/plugin' % rtp, self._nvim._init),
})
