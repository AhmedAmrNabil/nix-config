{ configPath, ... }: {
  flake.nixosModules.nh =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        pkgs.nh
      ];
      environment.sessionVariables = {
        NH_FLAKE = configPath;
      };
      environment.shellAliases = {
        nrs = "nh os switch";
        hrs = "nh home switch";
        wsl-nix-clean = "nh clean all --keep 1";
      };
    };
}
