{ self, ... }: {
  perSystem =
    { pkgs, lib, ... }:

    let
      d = self.lastModifiedDate;
      buildDate = "${builtins.substring 0 4 d}-${builtins.substring 4 2 d}-${builtins.substring 6 2 d}";

      variants = [
        # AOSP Variants
        {
          name = "aosp";
          romType = "aosp";
          withRoot = false;
          rootSolution = "none";
          withSusfs = false;
        }
        {
          name = "resukisu-aosp";
          romType = "aosp";
          withRoot = true;
          rootSolution = "resukisu";
          withSusfs = false;
        }
        {
          name = "ksu-next-aosp";
          romType = "aosp";
          withRoot = true;
          rootSolution = "ksu-next";
          withSusfs = false;
        }
        {
          name = "resukisu-susfs-aosp";
          romType = "aosp";
          withRoot = true;
          rootSolution = "resukisu";
          withSusfs = true;
        }
        {
          name = "ksu-next-susfs-aosp";
          romType = "aosp";
          withRoot = true;
          rootSolution = "ksu-next";
          withSusfs = true;
        }

        # One UI Variants (mapped to 'main' on stock)
        {
          name = "oneui";
          romType = "oneui";
          withRoot = false;
          rootSolution = "none";
          withSusfs = false;
        }
        {
          name = "resukisu-oneui";
          romType = "oneui";
          withRoot = true;
          rootSolution = "resukisu";
          withSusfs = false;
        }
        {
          name = "ksu-next-oneui";
          romType = "oneui";
          withRoot = true;
          rootSolution = "ksu-next";
          withSusfs = false;
        }
        {
          name = "resukisu-susfs-oneui";
          romType = "oneui";
          withRoot = true;
          rootSolution = "resukisu";
          withSusfs = true;
        }
        {
          name = "ksu-next-susfs-oneui";
          romType = "oneui";
          withRoot = true;
          rootSolution = "ksu-next";
          withSusfs = true;
        }
      ];

      allPackages = lib.listToAttrs (
        map (v: {
          name = "a52sxq-kernel-${v.name}";
          value = pkgs.callPackage ../packages/a52sxq-kernel/package.nix {
            inherit buildDate;
            inherit (v)
              withSusfs
              romType
              withRoot
              rootSolution
              ;
          };
        }) variants
      );
    in
    {
      packages =
        lib.filterAttrs (_: v: lib.isDerivation v) (
          lib.packagesFromDirectoryRecursive {
            inherit (pkgs) callPackage newScope;
            directory = ../packages;
          }
        )
        // allPackages;
    };
}
