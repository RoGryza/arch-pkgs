local manifest = import 'lib/manifest.libsonnet';
local base = import 'modules/base.jsonnet';
local neovim = import 'modules/neovim/main.jsonnet';

(manifest(base + neovim {
   maintainer: 'Rodrigo Gryzinski <rogryza@gmail.com>',
   pkgname: 'rogryza',
   pkgver: '0.0.1',
   pkgrel: 1,
   pkgdesc: 'Personal config files',
   url: 'https://github.com/RoGryza/arch-pkgs',
   license: ['MIT'],
   _license: importstr './LICENSE',
 })._output)
