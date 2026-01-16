{
  config,
  pkgs,
  lib,
  localPkgs,
  ...
}:
let
  cfg = config.apps.wps-office;
in
{
  options.apps.wps-office = {
    enable = lib.mkEnableOption "WPS Office suite with extra fonts";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wpsoffice
      localPkgs.wps-fonts
    ];
  };
}
