{ pkgs, ... }:
pkgs.st.overrideAttrs (old: {
  patches = [
    (builtins.fetchurl {
      url = "https://st.suckless.org/patches/xresources/st-xresources-20200604-9ba7ecf.diff";
      sha256 = "0nsda5q8mkigc647p1m8f5jwqn3qi8194gjhys2icxji5c6v9sav";
    })
  ];
})
