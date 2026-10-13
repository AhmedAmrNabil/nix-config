{
  flake.nixosModules.microsoft-edge = {
    # System policy fixing the warning
    environment.etc."opt/edge/policies/managed/policies.json".text = builtins.toJSON {
      CommandLineFlagSecurityWarningsEnabled = false;
    };
  };

  flake.homeModules.microsoft-edge = { pkgs, ... }: {
    home.packages = [ pkgs.microsoft-edge ];
  };
}
