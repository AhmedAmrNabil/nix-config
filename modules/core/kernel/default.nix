{
  config,
  pkgs,
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
    boot.kernelPackages = pkgs.linuxPackages_7;

    boot.kernelModules = [
      "ntsync"
    ];
  };
}
