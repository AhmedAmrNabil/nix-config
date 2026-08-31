{
  perSystem = { pkgs, lib, ... }: {
    packages = lib.filterAttrs (_: v: lib.isDerivation v) (
      lib.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage newScope;
        directory = ../packages;
      }
    );
  };
}
