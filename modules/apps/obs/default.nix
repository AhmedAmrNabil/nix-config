{
  flake.nixosModules.obs =
    {
      pkgsUnstable,
      ...
    }:
    {
      programs.obs-studio = {
        enable = true;
        package = (
          pkgsUnstable.obs-studio.override {
            cudaSupport = true;
          }
        );
        enableVirtualCamera = false;
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
      # virtualCamera custom config
      security.polkit.enable = true;
      v4l2loopback.devices = [
        {
          name = "OBS Cam";
          index = 1;
        }
      ];
    };
}
