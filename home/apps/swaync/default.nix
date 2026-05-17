{
  config,
  lib,
  ...
}:
let
  cfg = config.apps.swaync;
in
{
  options.apps.swaync = {
    enable = lib.mkEnableOption "Swaync with custom config";
  };
  config = lib.mkIf cfg.enable {
    services.swaync.enable = true;

    # will currently have impure file for customization
    xdg.configFile."swaync/config.json" = lib.mkForce {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/apps/swaync/config.json";
    };

    xdg.configFile."swaync/style.css" = lib.mkForce {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/apps/swaync/style.css";
    };
  };
}
