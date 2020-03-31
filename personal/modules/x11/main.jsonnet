local files = import 'lib/files.libsonnet';
local util = import 'lib/util.libsonnet';
local submodules = [
  import './autocutsel.jsonnet',
  import './dwm.jsonnet',
  import './st.jsonnet',
];

util.mergeAll(submodules, {
  local manifest = self,

  _depends+:: [
    'adobe-source-code-pro-fonts',
    'xorg-server',
    'xorg-xinit',
  ],

  _keymap+:: {
    x11: null,
  },

  _files+:: {
    'etc/X11/xinit/xinitrc': files.bash {
      executable: true,
      replace: true,
      content: |||
        #!/bin/sh

        xrdb -merge /etc/X11/xinit/.Xresources

        if [ -d /etc/X11/xinit/xinitrc.d ] ; then
          for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
            [ -x "$f" ] && . "$f"
          done
          unset f
        fi

        xsetroot -cursor_name left_ptr
        xrandr --auto

        errorlog="$HOME/.xsession-errors"
        # Start with a clean log file every time
        if ( cp /dev/null "$errorlog" 2> /dev/null ); then
          chmod 600 "$errorlog"
          exec %(wm)s > "$errorlog" 2>&1
        fi
      ||| % { wm: manifest._x11.wm.command },
    },
    'etc/X11/xinit/.Xresources': {
      content: importstr './Xresources',
    },
    [if manifest._keymap.x11 != null then 'etc/X11/xorg.conf.d/00-keyboard.conf']: {
      content: |||
        Section "InputClass"
          Identifier "system-keyboard"
          MatchIsKeyboard "on"
          Option "XkbLayout" "%s"
        EndSection
      ||| % manifest._keymap.x11,
    },
  } + util.mapPairs(
    function(k, v) [
      'etc/X11/xinit/xinitrc.d/99-%s.sh' % k,
      files.bash { content: '#!/bin/bash\n%s' % v, executable: true },
    ],
    manifest._x11.autostart,
  ),

  _x11+:: {
    wm+: {
      command: error 'wm command is required',
    },
    autostart+: {
    },
  },
})
