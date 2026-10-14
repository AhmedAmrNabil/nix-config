{
  flake.homeModules.bat = {
    programs.bat.enable = true;
    home.shellAliases = {
      cat = "bat --paging=never -p";
    };
  };
}
