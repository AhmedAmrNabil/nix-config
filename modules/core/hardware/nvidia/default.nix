{
  config,
  lib,
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
    hardware.nvidia.open = true; # see the note above
    hardware.nvidia.modesetting.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}
