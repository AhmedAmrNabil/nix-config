let
  scrcpyCameraIdx = 2;
in
{
  flake.nixosModules.scrcpy = {
    v4l2loopback.devices = [
      {
        name = "scrcpy Cam";
        index = scrcpyCameraIdx;
      }
    ];
  };

  flake.homeModules.scrcpy =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        scrcpy
        (pkgs.writeShellScriptBin "start-scrcpy-camera" ''
          #bash
          exec ${pkgs.scrcpy}/bin/scrcpy \
            --video-source=camera \
            --v4l2-sink=/dev/video${toString scrcpyCameraIdx} \
            --camera-id=0 \
            --camera-size=1280x720 \
            --no-audio \
            --no-audio-playback "$@"
        '')
      ];
    };
}
