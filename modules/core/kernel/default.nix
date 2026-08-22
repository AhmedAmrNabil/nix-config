{
  flake.nixosModules.kernel = { pkgs, ... }: {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.kernelModules = [
      "ntsync"
    ];
  };
}
