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
    eval `dbus-launch --auto-syntax`
    systemctl --user import-environment DISPLAY

    if [ -d /etc/X11/xinit/xinitrc.d ] ; then
      for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
      done
      unset f
    fi

    while true; do
      xsetroot -name "BAT $(cat /sys/class/power_supply/BAT0/capacity)% | $(date '+%a %d/%m %R')"
      sleep 1m
    done &

    xrdb -merge ~/.Xresources
    '';
  };
  xresources.extraConfig = builtins.readFile (
    pkgs.fetchFromGitHub {
      owner = "dracula";
      repo = "xresources";
      rev = "8de11976678054f19a9e0ec49a48ea8f9e881a05";
      sha256 = "12wmjynk0ryxgwb0hg4kvhhf886yvjzkp96a5bi9j0ryf3pc9kx7";
    } + "/Xresources"
  );

  programs.rofi.enable = true;
}
