{ pkgs, ... }:
let
  my-st = pkgs.callPackage ../../derivations/st.nix {};
  my-dwm = with pkgs; (callPackage ../../derivations/dwm {
    cmds = {
      run = "${rofi}/bin/rofi -modi drun -show drun";
      term = "${my-st}/bin/st";
      tmux = "${mt-st}/bin/st -e ${tmux}/bin/tmux new-session";
      browser = "/usr/bin/firefox";
      lock = "${slock}/bin/slock";
      pass = "${pass}/bin/passmenu";
    };
  });
in {
  home.packages = with pkgs; [
    my-dwm
    my-st
  ];

  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager.command = "${my-dwm}/bin/dwm";

    initExtra = ''
    ${pkgs.autocutsel}/bin/autocutsel -fork &
    ${pkgs.autocutsel}/bin/autocutsel -selection PRIMARY -fork &
    '';
  };
}
