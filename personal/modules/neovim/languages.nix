{ pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      vim-javascript
      vim-jsonnet
      vim-nix
      {
        plugin = yats-vim;
        config = "set re=0";
      }
      {
        # TODO figure out why overlays aren't working
        plugin = pkgs.vimUtils.buildVimPlugin {
          pname = "vim-svelte";
          src = (import ../../nix/sources.nix).vim-svelte;
          version = "0";
          postPatch = "rm Makefile";
        };
        config = ''
        let g:svelte_preprocessor_tags = [
        \ { 'name': 'ts', 'tag': 'script', 'as': 'typescript' }
        \ ]
        let g:svelte_preprocessors = ['ts']
        '';
      }
    ];

    ale.fixers = {
      javascript = [ "prettier" "eslint" ];
      typescript = [ "prettier" "eslint" ];
      svelte = [ "prettier" "eslint" ];
    };

    # TODO manage jdtls installation
    lsc.serverCommands.java = "jdtls";
    # TODO manage rust and cargo components installation
    lsc.serverCommands.rust = "rust-analyzer";

    lsc.serverCommands.ts = "${pkgs.nodePackages.typescript-language-server} --stdio";
  };
}
