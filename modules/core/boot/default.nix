{
  config,
  lib,
  ...
}:
let
  cfg = config.core.boot;
in
{
  options.core.boot = {
    enable = lib.mkEnableOption "Boot configuration management";
  };
  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
    };
  };
}
