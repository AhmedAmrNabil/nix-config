{
  perSystem = { pkgs, ... }: {
    packages = pkgs.lib.packagesFromDirectoryRecursive {
      inherit (pkgs) callPackage newScope;
      directory = ../packages;
    };
  };
}
