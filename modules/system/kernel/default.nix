{
  flake.nixosModules.kernel = { pkgs, ... }: {
    boot.kernelPackages = pkgs.linuxPackages_7_2;

    boot.kernelModules = [
      "ntsync"
    ];
  };
}
