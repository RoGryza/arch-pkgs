{ config, pkgs, lib, ...  }:
with lib;
let
  inherit (config.xsession) programs;
  sources = import ../../nix/sources.nix;
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
    ./notifications
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

    programs.alacritty = {
      enable = true;
      defaultSettings = {
        window.dynamic_title = false;
        key_bindings = [
          {
            key = "F6";
            command.program = "toggle-theme";
          }
        ];
      };
      themes.light.colors = {
        primary.background = "0xeeeeee";
        primary.foreground = "0x878787";

        cursor.text = "0xeeeeee";
        cursor.cursor = "0x878787";

        normal.black = "0xeeeeee";
        normal.red = "0xaf0000";
        normal.green = "0x008700";
        normal.yellow = "0x5f8700";
        normal.blue = "0x0087af";
        normal.magenta = "0x878787";
        normal.cyan = "0x005f87";
        normal.white = "0x444444";

        bright.black = "0xbcbcbc";
        bright.red = "0xd70000";
        bright.green = "0xd70087";
        bright.yellow = "0x8700af";
        bright.blue = "0xd75f00";
        bright.magenta = "0xd75f00";
        bright.cyan = "0x005faf";
        bright.white = "0x005f87";
      };
      themes.dark.colors = {
        primary.background = "#282a36";
        primary.foreground = "#f8f8f2";

        normal.black = "#000000";
        normal.red = "#ff5555";
        normal.green = "#50fa7b";
        normal.yellow = "#f1fa8c";
        normal.blue = "#caa9fa";
        normal.magenta = "#ff79c6";
        normal.cyan = "#8be9fd";
        normal.white = "#bfbfbf";

        bright.black = "#575b70";
        bright.red = "#ff6e67";
        bright.green = "#5af78e";
        bright.yellow = "#f4f99d";
        bright.blue = "#caa9fa";
        bright.magenta = "#ff92d0";
        bright.cyan = "#9aedfe";
        bright.white = "#e6e6e6";
      };
    };

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
