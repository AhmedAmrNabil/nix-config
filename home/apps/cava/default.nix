{
  config,
  lib,
  ...
}:
let
  cfg = config.apps.cava;
in
{
  options.apps.cava = {
    enable = lib.mkEnableOption "Cava audio visualizer with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.cava.enable = true;
    xdg.configFile."cava/config" = {
      source = config.lib.file.mkOutOfStoreSymlink (builtins.toString ./config);
    };
  };
}
