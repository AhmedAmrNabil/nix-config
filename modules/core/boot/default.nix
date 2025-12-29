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
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    boot.initrd.verbose = false;
    boot.consoleLogLevel = 3;
    boot.kernelParams = [
      "udev.log_priority=3"
      "boot.shell_on_fail"
      "rd.systemd.show_status=auto"
    ];
  };
}
