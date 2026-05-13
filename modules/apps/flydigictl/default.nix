{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.apps.flydigictl;
in
{
  options.apps.flydigictl = {
    enable = lib.mkEnableOption "Flydigictl service and CLI tool";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.flydigictl ];
    services.dbus.packages = [ pkgs.flydigictl ];
    systemd.packages = [ pkgs.flydigictl ];
  };
}
