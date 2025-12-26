{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.core.fonts;
in
{
  options.core.fonts = {
    enable = lib.mkEnableOption "Enable default font packages and configurations";
  };

  config = lib.mkIf cfg.enable {

    fonts.packages = with pkgs; [
      noto-fonts
    ];

    # Optional: Enable fontconfig tweaks
    fonts.fontconfig = {
      enable = true;
    };

    home-manager.users.${username} =
      { config, lib, ... }:
      {
        xdg.configFile."fontconfig/fonts.conf" = lib.mkForce {
          source = config.lib.file.mkOutOfStoreSymlink (builtins.toString "/fonts.conf");
        };

        xdg.configFile."fontconfig/conf.d/90-arabic.conf" = lib.mkForce {
          source = config.lib.file.mkOutOfStoreSymlink (builtins.toString "/90-arabic.conf");
        };
      };

  };
}
