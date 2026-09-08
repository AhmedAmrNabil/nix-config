{
  flake.homeModules.nh =
    {
      dotfilesDir,
      ...
    }:
    {
      programs.nh = {
        enable = true;
        flake = dotfilesDir;
      };

      home.shellAliases = {
        nrs = "nh os switch";
        hrs = "nh home switch";
      };
    };
}
