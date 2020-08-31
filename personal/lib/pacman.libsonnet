local util = import 'lib/util.libsonnet';

{
  conf:: {
    _output:: std.lines(util.mapToArray(
      function(section, fields)
        '[%s]\n%s' % [section, $.confSection(fields)],
      self,
    )),
  },

  confSection:: function(fields) std.lines(util.mapToArray(
    function(k, v)
      '%s%s' % [k, $.formatter(v)],
    fields
  )),

  formatter: util.formatter({
    string: function(_, v) ' = %s' % v,
    array: function(_, v) ' = %s' % std.join(' ', v),
    'null': function(_, _v) '',
  }),

  manifest:: {
    local manifest = self,

    _pacman+:: {
      config+:: $.conf {
        options+: {
          HoldPkg: ['pacman', 'glibc'],
          Architecture: 'auto',
          CheckSpace: null,
          SigLevel: 'Required DatabaseOptional',
          LocalFileSigLevel: 'Optional',
        },
        core+: {
          Include: '/etc/pacman.d/mirrorlist',
        },
        extra+: {
          Include: '/etc/pacman.d/mirrorlist',
        },
        community+: {
          Include: '/etc/pacman.d/mirrorlist',
        },
      },
    },
    _pacmand+:: {},

    _files+:: util.mapPairs(
      function(k, v)
        [
          'etc/pacman.d/%s' % k,
          {
            content: $.confSection(v),
          },
        ],
      self._pacmand,
    ) + {
      'etc/pacman.conf': {
        content: manifest._pacman.config._output,
        replace: true,
      },
    },
  },
}
