let
  mkPackages =
    pkgs:
    (pkgs.lib.packagesFromDirectoryRecursive {
      inherit (pkgs) callPackage newScope;
      directory = ../packages;
    });
in
{
  flake.overlays.packages = final: prev: mkPackages prev;
  perSystem = { pkgs, ... }: {
    packages = mkPackages pkgs;
  };
}
