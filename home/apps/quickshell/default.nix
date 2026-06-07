{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.apps.quickshell;
in
{
  options.apps.quickshell = {
    enable = lib.mkEnableOption "quick shell with custom config";
  };
  config = lib.mkIf cfg.enable {
    programs.quickshell.enable = true;
    qt.enable = true;
    home.packages = [ pkgs.kdePackages.qtdeclarative ];
    xdg.configFile."quickshell".source = lib.mkForce (config.lib.utils.mkMutableSymlink ./config);
  };
}
