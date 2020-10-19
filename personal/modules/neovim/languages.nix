{ pkgs, ... }:
{
  programs.neovim = {
    configure = {
      packages.rogryza-languages.start = with pkgs.vimPlugins; [
        vim-javascript
        vim-jsonnet
        vim-nix
      ];
    };

    # TODO manage jdtls installation
    lsc.serverCommands.java = "jdtls";
    # TODO manage rust and cargo components installation
    lsc.serverCommands.rust = "rust-analyzer";
  };
}
