{
  config,
  lib,
  ...
}:
let
  cfg = config.core.audio;
in
{
  options.core.audio = {
    enable = lib.mkEnableOption "Enable audio configuration options";
  };
  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      extraConfig.pipewire."10-clock" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [
            44100
            48000
            96000
          ];
          "default.clock.quantum" = 64;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 2048;
        };
      };
    };
    boot.kernel.sysctl = {
      "dev.hpet.max-user-freq" = 2048;
    };
  };
}
