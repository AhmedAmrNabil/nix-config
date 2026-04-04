{
  config,
  pkgsUnstable,
  lib,
  ...
}:
let
  cfg = config.core.kernel;
in
{
  options.core.kernel = {
    enable = lib.mkEnableOption "Kernel configuration management";
  };
  config = lib.mkIf cfg.enable {
    # use the latest kernel
    boot.kernelPackages = pkgsUnstable.linuxPackages_latest;

    boot.kernelModules = [
      "ntsync"
    ];
  };
}
