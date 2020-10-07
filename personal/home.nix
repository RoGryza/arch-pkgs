{ pkgs ? import ./nix/nixpkgs.nix, ... }:
with
  pkgs.lib;
{
  home.packages = [
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    history.path = ".histfile";
    history.size = 65536;
    history.ignoreDups = true;
    oh-my-zsh.enable = true;
    oh-my-zsh.plugins = [
      "cargo"
      "colorize"
      "docker"
      "kubectl"
      "fasd"
      "pass"
      "git"
      "gpg-agent"
      "zsh_reload"
    ];

    initExtra =
      let
        pfmt = f: t: "%{\$${f}%}${t}%{$reset_color%}";
        prompt = strings.concatStrings [
          (pfmt "fg[magenta]" "%n")
          "@"
          (pfmt "fg[yellow]" "%m")
          " "
          (pfmt "fg_bold[green]" "%~")
          " "
          "$(git_prompt_info)"
      ];
      in
        ''
        # Prompt
        autoload -Uz promptinit && promptinit
        function custom_prompt() {
          echo "$CUSTOM_PS1"
        }

        CUSTOM_PS1='> '
        PROMPT="${prompt}"$'\n'"$(custom_prompt)"

        # Don't stop output on ^S
        stty stop undef
        stty start undef

        source /usr/share/doc/pkgfile/command-not-found.zsh
        ${builtins.readFile lib/keyboard.zsh}
        '';

      shellAliases = {
        v = "vim";
        ipython = "ipython --no-banner --no-confirm-exit";
        rtv = "rtv --enable-media";
        ls = "lsd";
        tree = "lsd --tree";
        xp = "xclip -selection p";
        xpo = "xclip -sepection p -o";
      };
  };

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
    enableZshIntegration = true;
    stdlib = builtins.readFile lib/direnvrc;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "qt";
    sshKeys = ["8D9342B7F994DE2B879A03F4CF270B470301BE9C"];
  };

  programs.ssh = {
    enable = true;
    serverAliveInterval = 60;
  };
}
