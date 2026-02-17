{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.core.hardware.nvidia;
in
{
  options.core.hardware.nvidia = {
    enable = lib.mkEnableOption "Nvidia configuration options";
  };
  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      nvidiaSettings = true;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
