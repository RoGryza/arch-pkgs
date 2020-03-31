{
  _depends+:: ['autocutsel'],

  _x11+:: {
    autostart+: {
      autocutsel: |||
        autocutsel -fork &
        autocutsel -selection PRIMARY -fork &
      |||,
    },
  },
}
