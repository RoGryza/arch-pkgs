{
  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
    enableZshIntegration = true;
    stdlib = builtins.readFile ./direnvrc;
  };
}
