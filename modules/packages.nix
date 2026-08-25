let
  mkPackages =
    pkgs:
    (pkgs.lib.packagesFromDirectoryRecursive {
      inherit (pkgs) callPackage newScope;
      directory = ../packages;
    })
    // {
      prismlauncher-9 = pkgs.callPackage ../packages/prism-launcher-9/package.nix {
        jdks = [
          pkgs.jdk17
          pkgs.jdk25
        ];
      };
    };
in
{
  flake.overlays.packages = final: prev: mkPackages prev;
  perSystem = { pkgs, ... }: {
    packages = mkPackages pkgs;
  };
}
