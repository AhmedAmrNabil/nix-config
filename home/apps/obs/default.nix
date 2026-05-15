{
  config,
  lib,
  pkgsUnstable,
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
      package = (
        pkgsUnstable.obs-studio.override {
          cudaSupport = true;
        }
      );
      plugins = with pkgsUnstable.obs-studio-plugins; [
        droidcam-obs
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
      ];
    };
  };
}
