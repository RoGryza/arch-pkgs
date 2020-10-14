#!/bin/bash
set -euo pipefail

RELEASE_NAME=$(printf "$(cat pkg/PKGBUILD)"'\necho $pkgver-$pkgrel\n' | bash)
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
cd pkg && gh release upload --clobber 0.0.1-1 \
  rogryza.db "rogryza-$RELEASE_NAME-x86_64.pkg.tar.zst"
