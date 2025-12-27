{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.apps.obs;
in
{
  options.apps.obs = {
    enable = lib.mkEnableOption "OBS studio with plugins";
  };
  config = lib.mkIf cfg.enable {

    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      package = (
        pkgs.obs-studio.override {
          cudaSupport = true;
        }
      );
      plugins = with pkgs.obs-studio-plugins; [
        droidcam-obs
      ];
    };
  };
}
