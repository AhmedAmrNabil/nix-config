{
  lib,
  ...
}:
{
  flake.homeModules.waybar =
    {
      config,
      pkgsUnstable,
      ...
    }:
    {
      home.packages = with pkgsUnstable; [
        waybar
      ];
      xdg.configFile."waybar/config.jsonc" = lib.mkForce {
        source = config.lib.utils.mkMutableSymlink ./config.jsonc;
      };
      xdg.configFile."waybar/style.css" = lib.mkForce {
        source = config.lib.utils.mkMutableSymlink ./style.css;
      };
    };
}
