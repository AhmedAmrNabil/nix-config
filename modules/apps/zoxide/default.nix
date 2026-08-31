{
  flake.homeModules.zoxide = {
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}
