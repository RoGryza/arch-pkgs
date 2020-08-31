local services = import 'lib/services.libsonnet';

{
  local manifest = self,

  _networkConf:: {
    local conf = self,
    _iface:: error 'No interface for networkConf',
    _routeMetric:: error 'No routeMetric for networkConf',
    Match: { Name: conf._iface },
    Network: { DHCP: 'yes ' },
    DHCP: { RouteMetric: conf._routeMetric },
    _output:: { content: services.unit(conf) },
  },

  _network:: {
    wlan: 'wlp7s0',
    eth: 'enp8s0',
  },

  _systemd+:: {
    services+:: {
      'systemd-networkd.service': true,
      'systemd-resolved.service': true,
      ['wpa_supplicant@%s.service' % manifest._network.wlan]: true,
    },
  },

  _files+:: {
    'etc/systemd/network/20-wired.network': (manifest._networkConf {
                                               _iface:: manifest._network.eth,
                                               _routeMetric: 10,
                                             })._output,
    'etc/systemd/network/25-wireless.network': (manifest._networkConf {
                                                  _iface:: manifest._network.wlan,
                                                  _routeMetric: 20,
                                                })._output,
  },
}
