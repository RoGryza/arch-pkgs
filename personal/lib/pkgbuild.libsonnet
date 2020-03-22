local util = import 'lib/util.libsonnet';

{
  var:: function(name, val) if val != null then '%s=%s' % [name, util.formatBash(val)],
  varBlock:: function(obj, names) std.lines([
    $.var(name, obj[name])
    for name in names
    if obj[name] != null
  ]),
  fun:: function(name, val)
    if val != null then
      'function %s() {\n%s\n}' %
      [name, if std.isArray(val) then std.lines(val) else val],
  funBlock:: function(obj, names) std.lines([
    $.fun(name, obj[name])
    for name in names
    if obj[name] != null
  ]),

  manifest:: {
    maintainer: error 'Required parameter maintainer',
    pkgname: error 'Required parameter pkgname',
    pkgver: error 'Required parameter pkgver',
    pkgrel: error 'Required parameter pkgrel',
    pkgdesc: null,
    arch: ['x86_64'],
    url: null,
    license: [],

    source: [],
    sha256sums: ['SKIP' for _ in self.source],

    depends: std.set(self._depends),
    _depends:: [],

    local installContent = std.lines(std.prune(util.mapToArray(
      $.fun,
      self._installFunctions,
    ))),
    install: if !util.nullOrEmpty(installContent) then self.pkgname + '.install',
    _installFunctions:: {},

    _check:: [],
    _package:: [],
    local toNullOrLines = function(v) if std.length(v) > 0 then std.lines(v) else null,
    check: toNullOrLines(self._check),
    package: toNullOrLines(self._package),

    _PKGBUILD:: [
      '# Maintainer: ' + self.maintainer,
      $.varBlock(self, ['pkgname', 'pkgver', 'pkgrel', 'pkgdesc', 'arch', 'url', 'license']),
      '',
      $.varBlock(self, ['install']),
      '',
      $.varBlock(self, ['depends']),
      '',
      $.varBlock(self, ['source', 'sha256sums']),
      '',
      $.funBlock(self, ['check', 'package']),
    ],

    local manifest = self,
    _output:: {
      PKGBUILD: toNullOrLines(manifest._PKGBUILD),
      [if manifest.install != null then manifest.install]: installContent,
    },
  },
}
