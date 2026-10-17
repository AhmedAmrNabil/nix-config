{
  flake.homeModules.devenv = {
    # it auto handles integration per shell cuz its enabled top level in home-manager
    programs.devenv = {
      enable = true;
    };
  };
}
