{ config, pkgs, lib, ...  }:
with lib;
let
  sources = import ../../nix/sources.nix;
  my-st = pkgs.callPackage ../../derivations/st {};
  my-dwm = with pkgs; (callPackage ../../derivations/dwm {
    cmds = {
      run = "${rofi}/bin/rofi -modi drun -show drun";
      # TODO figure out why my-st.out doesn't work
      term = "st";
      tmux = "st -e ${tmux}/bin/tmux new-session";
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

  xsession.enable = true;
  xsession.windowManager.command = "${my-dwm}/bin/dwm";
  xsession.importedVariables = [ "LOCALE_ARCHIVE" ];
  home.file.".xinitrc" = {
    executable = true;
    text = ''
    eval `dbus-launch --auto-syntax`

    ${optionalString (config.xsession.importedVariables != [])
      ("systemctl --user import-environment " + toString (unique config.xsession.importedVariables))}

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

    ${pkgs.autocutsel}/bin/autocutsel -fork &
    ${pkgs.autocutsel}/bin/autocutsel -selection PRIMARY -fork &

    xrdb -merge ~/.Xresources

    errorlog="$HOME/.xsession-errors"
    if ( cp /dev/null "$errorlog" 2> /dev/null ); then
      chmod 600 "$errorlog"
      exec ${config.xsession.windowManager.command} > "$errorlog" 2>&1
    fi
    '';
  };

  xresources.properties = {
    "*.font" = "Source Code Pro:pixelsize=18";
    "rofi.font" = "Source Code Pro 14";
  };
  xresources.extraConfig = builtins.readFile (sources.xresources-theme);

  programs.rofi.enable = true;
}
