{ config, pkgs, lib, ...  }:
with lib;
let
  inherit (config.xsession) programs;
  sources = import ../../nix/sources.nix;
  # TODO expose config option to pick nixGL wrapper
  nixGLNvidia = (import sources.nixGL { inherit pkgs; }).nixGLNvidia;
  my-dwm = (pkgs.callPackage ../../derivations/dwm {
    fonts = [ "Ubuntu Mono Nerd Font:size=14" ];
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
  imports = [
    ./alacritty.nix
    ./screenshot.nix
  ];

  options =
    let
      mkProgramOption = attrs: mkOption (
        { type = with types; listOf str; } // attrs
      );
    in {
    xsession.programs = {
      launcher = mkProgramOption { };
      term = mkProgramOption { default = [ "xterm" ]; };
      browser = mkProgramOption { default = [ "/usr/bin/firefox" ]; };
      lock = mkProgramOption { default = [ "slock" ]; };
      pass = mkProgramOption { default = [ "${pkgs.pass}/bin/passmenu" ]; };
    };
  };

  config = {
    home.packages = with pkgs; [
      nerdfonts
      my-dwm
    ];

    xsession.enable = true;
    xsession.windowManager.command = "${my-dwm}/bin/dwm";
    fonts.fontconfig.enable = true;
    services.dwm-status = {
      enable = true;
      order = [ "battery" "network" "time" ];
      package = import sources.dwm-status {};
      extraConfig = {
        separator = "    ";
        battery = {
          charging = "▲";
          discharging = "▼";
          no_battery = "";
          icons = ["" "" "" "" "" "" "" "" "" "" ""];
        };
        network = {
          no_value = "";
          template = "直  {ESSID}";
        };
        time.format = "   %H:%M %d/%m/%Y";
      };
    };
    xsession.importedVariables = [
      "LOCALE_ARCHIVE"
      "LOCALE_ARCHIVE_2_32"
    ];
    xsession.initExtra = "xsetroot -solid rgb:00/00/00";
    xsession.profileExtra = config.programs.zsh.profileExtra;
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
