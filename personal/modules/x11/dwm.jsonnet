{
  _depends+:: ['rogryza-dwm', 'xorg-xsetroot'],
  _x11+:: {
    wm+: {
      command: '/usr/bin/dwm',
    },
    autostart+: {
      'dwm-statusbar': |||
        while true; do
          xsetroot -name "BAT $(cat /sys/class/power_supply/BAT0/capacity)% | $(date '+%a %d/%m %R')"
          sleep 1m
        done &
      |||,
    },
  },
}
