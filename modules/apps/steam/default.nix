{
  config,
  lib,
  ...
}:
let
  cfg = config.apps.steam;
in
{
  options.apps.steam = {
    enable = lib.mkEnableOption "Steam support";
  };
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # For Steam Remote Play
      dedicatedServer.openFirewall = true;
    };
  };
}
