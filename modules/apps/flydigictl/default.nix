{
  config,
  pkgs,
  lib,
  localPkgs,
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
    environment.systemPackages = [ localPkgs.flydigictl ];
    services.dbus.packages = [ localPkgs.flydigictl ];
    systemd.packages = [ localPkgs.flydigictl ];

  };
}
