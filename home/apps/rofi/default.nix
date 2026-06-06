{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.apps.rofi;
in
{
  options.apps.rofi = {
    enable = lib.mkEnableOption "Rofi with custom config";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi
    ];

    xdg.configFile."rofi/themes" = lib.mkForce {
      source = config.lib.utils.mkMutableSymlink ./themes;
      recursive = true;
    };

    xdg.configFile."rofi/config.rasi".source = config.lib.utils.mkMutableSymlink ./config.rasi;
  };
}
