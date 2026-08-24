{
  flake.nixosModules.obs =
    {
      pkgsUnstable,
      config,
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
        # see below, implemented the virtual camera option + scrcpy camera support
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

      # enabling virtual camera  + scrcpy camera support
      security.polkit.enable = true;
      boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      boot.kernelModules = [ "v4l2loopback" ];

      boot.extraModprobeConfig = ''
        options v4l2loopback devices=2 video_nr=1,2 card_label="OBS Cam","scrcpy Cam" exclusive_caps=1,1
      '';
    };
}
