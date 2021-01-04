{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.neovim;
  themesCfg = config.me.themes;

  inherit (builtins) readFile;

  colorsPlugin = config.lib.base16.templates {
    app = "neovim";
    template = pkgs.writeText "neovim-base16-template" (readFile ./colors.mustache);
    install = name: package:
      ''ln -s ${package} $out/share/vim-plugins/base16-colors/colors/base16-${name}.vim'';
    installPhase = ''mkdir -p $out/share/vim-plugins/base16-colors/colors'';
  } // { pname = "base16-colors"; };
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
    me.themes.hooks.neovim = ''
      for SRV in $(${pkgs.neovim-remote}/bin/nvr --serverlist); do
        ${pkgs.neovim-remote}/bin/nvr \
          --servername "$SRV" --nostart \
          --remote-send ":call MyRefresh()<CR>" || true
      done
    '';
  })
]
