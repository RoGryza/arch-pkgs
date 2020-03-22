local files = import 'lib/files.libsonnet';

{
  _depends+:: [
    'sudo',
    'git',
    'wget',
    'curl',
    'unzip',
    'p7zip',
    'pacman-contrib',
    'efibootmgr',
    'pv',
    'bat',
    'fd',
    'lsd',
    'ripgrep',
    'dhcpcd',
    'net-tools',
    'wpa_supplicant',
    'openssh',
    'gnupg',
  ],
  _files+:: {
    'etc/locale.conf': files.bash {
      content: 'LANG=en_US.UTF-8',
    },
    'etc/vconsole.conf': files.bash {
      content: 'KEYMAP=br-abnt2',
    },
    'etc/sudoers.d/wheel': {
      content: |||
        %wheel ALL=(ALL) ALL
        Defaults passwd_timeout=0
      |||,
      check: 'visudo --check --file=$FILE',
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
