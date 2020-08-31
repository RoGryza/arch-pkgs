local files = import 'lib/files.libsonnet';
local pacman = import 'lib/pacman.libsonnet';
local pb = import 'lib/pkgbuild.libsonnet';
local programs = import 'lib/programs.libsonnet';
local services = import 'lib/services.libsonnet';

function(c)
  pb.manifest + files.manifest + pacman.manifest + programs.manifest + services.manifest + c
