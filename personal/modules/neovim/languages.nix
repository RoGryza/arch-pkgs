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
    ];

    # TODO manage jdtls installation
    lsc.serverCommands.java = "jdtls";
    # TODO manage rust and cargo components installation
    lsc.serverCommands.rust = "rust-analyzer";

    lsc.serverCommands.ts = "${pkgs.nodePackages_latest.typescript-language-server} --stdio";
  };
}
