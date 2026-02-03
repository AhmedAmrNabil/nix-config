{
  config,
  lib,
  ...
}:
let
  cfg = config.apps.bat;
in
{
  options.apps.bat = {
    enable = lib.mkEnableOption "Bat: cat alternative with extra config";
  };
  config = lib.mkIf cfg.enable {
    programs.bat.enable = true;
    home.shellAliases = {
      cat = "bat --paging=never";
    };
  };
}
