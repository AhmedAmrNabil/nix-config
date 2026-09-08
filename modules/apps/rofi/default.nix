{
  lib,
  ...
}:
{
  flake.homeModules.rofi = { pkgs, config, ... }: {
    home.packages = with pkgs; [
      rofi
    ];

    xdg.configFile."rofi" = lib.mkForce {
      source = config.lib.utils.mkMutableSymlink ./config;
    };
  };
}
