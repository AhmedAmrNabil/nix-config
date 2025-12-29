{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.apps.plymouth;
in
{
  options.apps.plymouth = {
    enable = lib.mkEnableOption "Plymouth with themes";
  };
  config = lib.mkIf cfg.enable {
    boot = {
      plymouth = {
        enable = true;
        theme = "breeze";
        logo = "${pkgs.nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake-white.png";
        extraConfig = ''
          DeviceScale = 1;
        '';
      };
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];
    };
  };
}
