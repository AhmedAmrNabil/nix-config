{
  flake.nixosModules.kernel = { pkgs, ... }: {
    boot.kernelPackages = pkgs.linuxPackages_7_1;

    boot.kernelModules = [
      "ntsync"
    ];
  };
}
