{ config, lib, pkgs, ... }:
with lib;
let
  inherit (builtins) readFile;

  cfg = config.programs.git;
  hooks = pkgs.linkFarmFromDrvs "git-hooks" [
    (pkgs.writeTextFile {
      name = "pre-push";
      text = readFile ./pre-push;
      executable = true;
      checkPhase = ''${pkgs.stdenv.shell} -n $out'';
    })
  ];
in mkMerge [
  (mkIf cfg.enable {
    home.packages = with pkgs; [ git github-cli ];

    programs.git.extraConfig = {
      core.hooksPath = "${hooks}";
      pull.rebase = false;
    };
  })
]
