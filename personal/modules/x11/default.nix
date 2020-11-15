{ config, pkgs, lib, ...  }:
with lib;
let
  inherit (config.xsession) programs;
  sources = import ../../nix/sources.nix;
  my-st = pkgs.callPackage ../../derivations/st.nix {};
  my-dwm = (pkgs.callPackage ../../derivations/dwm {
    cmds =
      let
        cmdLine = xs: strings.concatStringsSep " " (map strings.escapeShellArg xs);
      in
      attrsets.mapAttrs (_: cmdLine) {
        run = programs.launcher;
        term = programs.term;
        tmux = programs.term ++ [
          "-e"
          "${pkgs.tmux}/bin/tmux"
          "new-session"
        ];
        browser = programs.browser;
        lock = programs.lock;
        pass = programs.pass;
      };
  });
in {
  imports = [ ./screenshot.nix ];

  options =
    let
      mkProgramOption = attrs: mkOption (
        { type = with types; listOf str; } // attrs
      );
    in {
    xsession.programs = {
      launcher = mkProgramOption { };
      term = mkProgramOption {
        # TODO figure out why my-st.out doesn't work
        default = [ "st" ];
      };
      browser = mkProgramOption { default = [ "/usr/bin/firefox" ]; };
      lock = mkProgramOption { default = [ "slock" ]; };
      pass = mkProgramOption { default = [ "${pkgs.pass}/bin/passmenu" ]; };
    };
  };

  config = let
    dwm-status = pkgs.writeScript "dwm-status" ''
      #!/bin/sh
      while true; do
        xsetroot -name "BAT $(cat /sys/class/power_supply/BAT0/capacity)% | $(date '+%a %d/%m %R')"
        sleep 1m
      done
    '';
  in {
    home.packages = with pkgs; [
      my-dwm
      my-st
    ];

    xsession.enable = true;
    xsession.windowManager.command = "${my-dwm}/bin/dwm";
    xsession.importedVariables = [
      "LOCALE_ARCHIVE"
      "LOCALE_ARCHIVE_2_32"
    ];
    xsession.initExtra = "xsetroot -solid rgb:00/00/00";
    xsession.profileExtra = config.programs.zsh.profileExtra;
    systemd.user.services.dwm-status = {
      Unit = {
        Description = "Update dwm status bar";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "hm-graphical-session.target" ];
      };

      Install = { WantedBy = [ "hm-graphical-session.target" ]; };

      Service = {
        Type = "simple";
        ExecStart = "${dwm-status.out}";
      };
    };
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

      ${dwm-status.out}&

      ${pkgs.autocutsel}/bin/autocutsel -fork &
      ${pkgs.autocutsel}/bin/autocutsel -selection PRIMARY -fork &

      xrandr --auto
      xrdb -merge ~/.Xresources
      ${config.xsession.initExtra}

      errorlog="$HOME/.xsession-errors"
      if ( cp /dev/null "$errorlog" 2> /dev/null ); then
        chmod 600 "$errorlog"
        exec ${config.xsession.windowManager.command} > "$errorlog" 2>&1
      fi
      '';
    };

    xresources.properties = {
      "*.font" = "DejaVu Sans Mono:pixelsize=18";
    };
    xresources.extraConfig = builtins.readFile "${(sources.solarized-xresources)}/Xresources.dark";
  };
}
