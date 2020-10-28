let
  pkgs = import ./nix/nixpkgs.nix {};
in
{ sources ? import ./nix/sources.nix, ...
}:
let
  home-manager = (import sources.home-manager { inherit pkgs; }).home-manager;
in
pkgs.mkShell {
  buildInputs = [
    pkgs.niv
    home-manager
    (pkgs.writeScriptBin "hm" ''
      ${home-manager}/bin/home-manager -f hosts.nix -A $(cat /etc/hostname) $@
    '')
  ];
}

