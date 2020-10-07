local manifest = import 'lib/manifest.libsonnet';
local util = import 'lib/util.libsonnet';

local modules = [
  import 'modules/base.jsonnet',
  import 'modules/docker.jsonnet',
  import 'modules/x11/main.jsonnet',
  import 'modules/network.jsonnet',
  import 'modules/pacman.jsonnet',
  import 'modules/python.jsonnet',
  import 'modules/vscode/main.jsonnet',
  import 'modules/neovim/main.jsonnet',
  import 'modules/rust.jsonnet',
  {
    maintainer: 'Rodrigo Gryzinski <rogryza@gmail.com>',
    pkgname: 'rogryza',
    pkgver: '0.0.5',
    pkgrel: 1,
    pkgdesc: 'Personal config files',
    url: 'https://github.com/RoGryza/arch-pkgs',
    license: ['MIT'],
    _license:: importstr '../LICENSE',

    _keymap+:: {
      console: 'br-abnt2',
      x11: 'br',
    },
  },
];

manifest(util.mergeAll(modules))
