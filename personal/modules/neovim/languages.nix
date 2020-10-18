{ pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      vim-javascript
      vim-jsonnet
      vim-nix
    ];

    # TODO manage jdtls installation
    lsc.serverCommands.java = "jdtls";
  };
}
