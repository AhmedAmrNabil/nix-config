{
  lib,
  ...
}:
{
  flake.homeModules.rofi = { pkgs, config, ... }: {
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
