{
  flake.homeModules.fish =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        plugins = [
          {
            name = "bass";
            src = pkgs.fishPlugins.bass.src;
          }
        ];
      };
    };
}
