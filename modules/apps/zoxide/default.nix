{
  flake.homeModules.zoxide =
    {
      config,
      ...
    }:
    {
      programs.zoxide = {
        enable = true;
        enableBashIntegration = config.programs.bash.enable;
        enableFishIntegration = config.programs.fish.enable;
        options = [ "--cmd cd" ];
      };
    };
}
