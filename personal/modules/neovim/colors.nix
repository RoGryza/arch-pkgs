{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.neovim;
  themesCfg = config.me.themes;

  inherit (builtins) readFile;

  colorsPlugin = pkgs.stdenv.mkDerivation (rec {
    name = "neovim-base16-colors";
    pname = name;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/share/vim-plugins/base16/colors
      for F in ${themesCfg.consumerBase16Dirs.neovim}/*; do
        ln -s "$F" "$out/share/vim-plugins/base16/colors/base16-$(basename $F).vim"
      done
    '';
    preferLocalBuild = true;
  });
in
mkMerge [
  (mkIf cfg.enable {
    programs.neovim.plugins = [{
      plugin = colorsPlugin;
      config = ''
        function! MyRefresh()
          execute "colorscheme base16-" . system('set-theme')
        endfunction

        augroup MyRefreshGroup
          au!
          autocmd VimEnter * call MyRefresh()
        augroup END
      '';
    }];
    me.themes.consumers.neovim = {
      template = pkgs.writeText "neovim-base16-template" (readFile ./colors.mustache);
      hook = ''
        for SRV in $(${pkgs.neovim-remote}/bin/nvr --serverlist); do
          ${pkgs.neovim-remote}/bin/nvr \
            --servername "$SRV" --nostart \
            --remote-send ":call MyRefresh()<CR>" || true
        done
      '';
    };
  })
]
