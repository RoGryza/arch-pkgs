local util = import 'lib/util.libsonnet';
{
  manifest:: {
    local manifest = self,

    _license:: null,
    _files+:: {
      [if manifest._license != null then 'usr/share/licenses/%s/LICENSE' % manifest.pkgname]: {
        content: manifest._license,
      },
    } + util.mapPairs(
      function(name, vars) [
        'etc/profile.d/%s.sh' % name,
        $.bash {
          content: std.lines(util.mapToArray(
            function(k, v) 'export %s=%s' % [k, util.formatBash(v)],
            vars
          )),
        },
      ],
      self._profile,
    ),

    local fileList = util.mapToArray(
      function(k, v)
        {
          content: error 'File content is required',
          check: null,
          mode: if self.executable then '0755' else '0644',
          executable: false,
          path: k,
          source: std.strReplace(k, '/', '_'),
          replace: false,
        } + v,
      self._files,
    ),

    _profile:: {},

    source+:: [f.source for f in fileList],

    _check+:: [
      f.check
      for f in fileList
      if f.check != null
    ],
    _package+:: [
      'install -Dm %(mode)s %(source)s "$pkgdir/%(path)s%(suffix)s"' % f {
        suffix: if self.replace then '.rogryza' else '',
      }
      for f in fileList
    ],

    _installFunctions+:: {
      _post_install_setup_files: [
        |||
          [ -f /%(path)s ] && cp /%(path)s /%(path)s.bak
          cp /%(path)s.rogryza /%(path)s
        ||| % f
        for f in fileList
        if f.replace
      ],

      post_install+: ['_post_install_setup_files'],
      post_upgrade+: ['_post_install_setup_files'],
      pre_remove+: [
        |||
          rm -f /%(path)s
          [ -f /%(path)s.bak ] && cp /%(path)s.bak /%(path)s
        ||| % f
        for f in fileList
        if f.replace
      ],
    },

    _output+:: {
      [f.source]: f.content
      for f in fileList
    },
  },

  bash:: {
    check: 'echo "Validating %(source)s" && bash -n %(source)s' % self,
  },
}
