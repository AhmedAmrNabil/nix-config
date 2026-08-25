{ pkgs }:
(pkgs.lib.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage newScope;
  directory = ./.; # adjust if this file lives elsewhere (e.g. ../packages)
})
// {
  # only needed because of the extra jdks argument
  prismlauncher-9 = pkgs.callPackage ./prism-launcher-9/package.nix {
    jdks = [
      pkgs.jdk17
      pkgs.jdk25
    ];
  };
}
