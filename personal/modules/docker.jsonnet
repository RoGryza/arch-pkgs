{
  _depends+:: ['docker'],
  _systemd+:: {
    services+:: {
      'docker.socket': true,
    },
  },
}
