{
  flake.homeModules.devenv =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      home.packages = with pkgs; [
        devenv
      ];
      programs.fish.shellInit = lib.optionalString config.programs.fish.enable ''
        devenv hook fish | source
      '';
      programs.bash.bashrcExtra = lib.optionalString config.programs.bash.enable ''
        eval "$(devenv hook bash)"
      '';
    };
}
