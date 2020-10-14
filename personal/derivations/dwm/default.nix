{ pkgs, lib, cmds, ... }:
pkgs.dwm.overrideAttrs (old: {
  patches = map builtins.fetchurl [
    {
      url = "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
      sha256 = "114xcy1qipq6cyyc051yy27aqqkfrhrv9gjn8fli6gmkr0x6pk52";
    }
    {
      url = "https://dwm.suckless.org/patches/nodmenu/dwm-nodmenu-6.2.diff";
      sha256 = "1z6b89aa2l9kpm1vydmm058l46w4xdafm5yfkjasa55m4kkb6xhp";
    }
    {
      url = "https://dwm.suckless.org/patches/systray/dwm-systray-6.2.diff";
      sha256 = "19m7s7wfqvw09z9zb3q9480n42xcsqjrxpkvqmmrw1z96d2nn3nn";
    }
  ];

  postPatch = let
    ccmds = with lib; mapAttrs
      (_: cmd: concatMapStringsSep ", " (s: ''"${s}"'') (splitString " " cmd))
      cmds;
  in ''
    substitute ${./config.h} config.h \
      --subst-var-by runcmd '${ccmds.run}' \
      --subst-var-by termcmd '${ccmds.term}' \
      --subst-var-by tmuxcmd '${ccmds.tmux}' \
      --subst-var-by browsercmd '${ccmds.browser}' \
      --subst-var-by lockcmd '${ccmds.lock}' \
      --subst-var-by passcmd '${ccmds.pass}'
  '';
})

