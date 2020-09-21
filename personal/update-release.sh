#!/bin/bash
set -euo pipefail

VERSION_SCRIPT='local m = import "rogryza.jsonnet"; "%s-%s" % [m.pkgver, m.pkgrel]'
RELEASE_NAME="$(jsonnet --jpath . --string --exec "$VERSION_SCRIPT")"
echo "Updating release for $RELEASE_NAME..."
make --silent db

# URL="repos/rogryza/arch-pkgs/releases/tags/$RELEASE_NAME"
# if $(gh api "$URL" >/dev/null 2>&1); then
#   read -r -p "Release already exists, overwrite? [y/N] " response
#   case "$response" in
#     [yY][eE][sS]|[yY])
#       ;;
#     *)
#       exit 1
#       ;;
#   esac
# else
#   echo "Creating release..."
#   gh release create "$RELEASE_NAME" --title "$RELEASE_NAME"
# fi

echo "Uploading files..."
cd out && gh release upload --clobber 0.0.1-1 \
  rogryza.db "rogryza-$RELEASE_NAME-x86_64.pkg.tar.zst"
