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
        enableVirtualCamera = true;
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
