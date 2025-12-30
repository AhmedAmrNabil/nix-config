{
  config,
  lib,
  pkgs,
  username,
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
      gamescopeSession.enable = true;
    };

    environment.systemPackages = with pkgs; [
      mangohud
    ];

    programs.gamemode.enable = true;

    home-manager.users.${username} = {
      xdg.desktopEntries.steam-gamescope = {
        name = "Steam (gamescope)";
        genericName = "Steam";
        exec = "${lib.getExe' pkgs.gamescope "gamescope"} -e -- ${lib.getExe' pkgs.steam "steam"} -tenfoot";
        icon = "steam";
        categories = [
          "Game"
        ];
      };
    };
  };
}
