{
  flake.nixosModules.nh =
    {
      pkgs,
      dotfilesDir,
      ...
    }:
    {
      environment.systemPackages = [
        pkgs.nh
      ];
      environment.sessionVariables = {
        NH_FLAKE = dotfilesDir;
      };
      environment.shellAliases = {
        nrs = "nh os switch";
        hrs = "nh home switch";
        wsl-nix-clean = "nh clean all --keep 1";
      };
    };
}
