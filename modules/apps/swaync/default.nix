{
  flake.homeModules.swaync =
    {
      config,
      lib,
      ...
    }:
    {
      services.swaync.enable = true;

      # will currently have impure file for customization
      xdg.configFile."swaync/config.json".source = lib.mkForce (
        config.lib.utils.mkMutableSymlink ./config.json
      );

      xdg.configFile."swaync/style.css".source = lib.mkForce (
        config.lib.utils.mkMutableSymlink ./style.css
      );
    };
}
