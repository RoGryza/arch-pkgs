{ pkgs, oldGlibcLocales, ... }:
with
  pkgs.lib;
{
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
        # Fix for nix locale
        export LOCALE_ARCHIVE_2_11="${oldGlibcLocales}/lib/locale/locale-archive"
        export LOCALE_ARCHIVE_2_21="${oldGlibcLocales}/lib/locale/locale-archive"
        export LOCALE_ARCHIVE_2_27="${pkgs.glibcLocales}/lib/locale/locale-archive"

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
        ${builtins.readFile ./keyboard.zsh}
        '';

      profileExtra = ''
      export LOCALE_ARCHIVE=/usr/bin/locale
      export XDG_DATA_DIRS=/usr/share:/usr/local/share
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
}
