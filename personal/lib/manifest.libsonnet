local files = import 'lib/files.libsonnet';
local pb = import 'lib/pkgbuild.libsonnet';
local programs = import 'lib/programs.libsonnet';

function(c)
  pb.manifest + files.manifest + programs.manifest + c
