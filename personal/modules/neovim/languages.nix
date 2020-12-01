{ pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      vim-javascript
      vim-jsonnet
      vim-nix
      vim-toml
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
      {
        # TODO overlays...
        plugin = pkgs.vimUtils.buildVimPlugin {
          pname = "vim-hcl";
          src = (import ../../nix/sources.nix).vim-hcl;
          version = "0";
        };
      }
      {
        # TODO overlays...
        plugin = pkgs.vimUtils.buildVimPlugin {
          pname = "vim-terraform";
          src = (import ../../nix/sources.nix).vim-terraform;
          version = "0";
          postPatch = "rm Makefile";
        };
        config = ''
        let g:terraform_align=1
        let g:terraform_fmt_on_save=1
        '';
      }
    ];

    ale.fixers = {
      javascript = [ "prettier" "eslint" ];
      typescript = [ "prettier" "eslint" ];
      svelte = [ "prettier" "eslint" ];
      rust = [ "rustfmt" ];
    };

    # TODO manage jdtls installation
    lsc.serverCommands.java = "jdtls";
    # TODO manage rust and cargo components installation
    lsc.serverCommands.rust = "${pkgs.rust-analyzer}/bin/rust-analyzer";

    lsc.serverCommands.ts = "${pkgs.nodePackages.typescript-language-server} --stdio";
  };
}
