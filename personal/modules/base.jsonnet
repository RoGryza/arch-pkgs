local files = import 'lib/files.libsonnet';

{
  local manifest = self,

  _depends+:: [
    'alsa-utils',
    'base',
    'autoconf',
    'automake',
    'binutils',
    'bison',
    'fakeroot',
    'file',
    'findutils',
    'flex',
    'gawk',
    'gcc',
    'gettext',
    'grep',
    'groff',
    'gzip',
    'libtool',
    'm4',
    'make',
    'pacman',
    'patch',
    'pkgconf',
    'sed',
    'texinfo',
    'which',
    'refind',
    'sudo',
    'git',
    'wget',
    'pkgfile',
    'curl',
    'unzip',
    'htop',
    'yay',
    'make',
    'man-db',
    'man-pages',
    'mediainfo',
    'p7zip',
    'pacman-contrib',
    'otf-fira-code',
    'ttf-fira-code',
    'efibootmgr',
    'pv',
    'bat',
    'fd',
    'lsd',
    'ripgrep',
    'openssh',
    'gnupg',
    'fasd',
    'zsh',
  ],
  _keymap+:: {
    console: null,
  },
  _directories+:: {
    'etc/sudoers.d': {
      mode: '0750',
    },
  },
  _files+:: {
    'etc/locale.conf': files.bash {
      content: 'LANG=en_US.UTF-8',
    },
    [if manifest._keymap.console != null then 'etc/vconsole.conf']: {
      content: 'KEYMAP=%s' % manifest._keymap.console,
    },
    'etc/sudoers.d/wheel': {
      content: |||
        %wheel ALL=(ALL) ALL
        Defaults passwd_timeout=0
      |||,
      check: 'visudo --check --file=%s' % self.source,
      mode: '0640',
    },
  },
  _installFunctions+:: {
    _base_post_upgrade: |||
      ln -sf /usr/share/zoneinfo/Brazil/East "/etc/localtime"
      sed 's/#en_US/en_US/' -i /etc/locale.gen
      locale-gen
    |||,

    post_install+: ['_base_post_upgrade'],
    post_upgrade+: ['_base_post_upgrade'],
  },
}
