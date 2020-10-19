let
  pkgs = import ./nix/nixpkgs.nix {};
in
{ sources ? import ./nix/sources.nix, ...
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.niv
    (import sources.home-manager {
      inherit pkgs;
    }).home-manager
  ];
}

