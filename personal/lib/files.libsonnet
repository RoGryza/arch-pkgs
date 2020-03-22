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
        } + v,
      self._files,
    ),

    _profile:: {},

    source+:: [f.source for f in fileList],

    _check+:: std.flattenArrays([
      ['export FILE=' + f.source, f.check]
      for f in fileList
      if f.check != null
    ]),
    _package+:: [
      'install -Dm %(mode)s %(source)s "$pkgdir/%(path)s"' % f
      for f in fileList
    ],

    _output+:: {
      [f.source]: f.content
      for f in fileList
    },
  },

  bash:: {
    check: 'echo "Validating $FILE" && bash -n $FILE',
  },
}
