{
  flake.homeModules.micro = {
    programs.micro = {
      enable = true;
    };

    home.sessionVariables = {
      EDITOR = "micro";
      VISUAL = "micro";
    };
  };
}
