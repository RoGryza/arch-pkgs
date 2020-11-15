{
  sources ? import ../nix/sources.nix,
  pkgs,
  ...
}:
pkgs.st.overrideAttrs (old: {
  patches = [
    sources.st-solarized-both
  ];
})
