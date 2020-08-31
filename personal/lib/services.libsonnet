local util = import 'lib/util.libsonnet';

{
  unit:: function(sections) std.lines(util.mapToArray(
    function(section, fields) std.lines(
      [
        '[%s]' % section,
      ] +
      util.mapToArray(
        function(k, v) '%s=%s' % [k, $.formatUnit(v)],
        fields,
      ),
    ),
    sections,
  )),

  formatUnit:: util.formatter({
    number: function(_, v) std.toString(v),
    string: function(_, v) std.toString(v),
    array: function(rec, v) std.join(' ', std.map(rec, v)),
  }),

  manifest:: {
    local manifest = self,

    local serviceList = util.mapToArray(
      function(k, v)
        {
          name: k,
          enable: false,
          content: null,
        } + if (std.isObject(v)) then v else { enable: v },
      manifest._systemd.services,
    ),

    _systemd+:: {
      _metaTarget:: 'rogryza.target',
      services+: {
        [manifest._systemd._metaTarget]: {
          content: {
            Unit: {
              Description: 'Dummy target for enabled services',
              Requires: 'multi-user.target',
              Wants: [
                svc.name
                for svc in serviceList
                if svc.enable && svc.name != manifest._systemd._metaTarget
              ],
            },
            Install: {
              WantedBy: 'multi-user.target',
            },
          },
        },
      },
    },

    _files+:: util.objectFromPairs([
      [
        'usr/lib/systemd/system/%s' % svc.name,
        {
          content: $.unit(svc.content),
          check: 'systemd-analyze verify %(source)s' % self,
        },
      ]
      for svc in serviceList
      if svc.content != null
    ]),

    _installFunctions+:: {
      _post_install+:: ['systemctl enable --now %s' % manifest._systemd._metaTarget],
      _post_upgrade+:: ['systemctl restart %s' % manifest._systemd._metaTarget],
      _pre_remove+:: ['systemctl disable %s' % manifest._systemd._metaTarget],
    },
  },
}
