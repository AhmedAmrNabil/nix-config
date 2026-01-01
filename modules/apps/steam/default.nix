{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.apps.steam;

  steamGamescopeSession = pkgs.stdenvNoCC.mkDerivation {
    name = "steam-gamescope-session";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/wayland-sessions
      cat > $out/share/wayland-sessions/steam-gamescope.desktop <<EOF
      [Desktop Entry]
      Name=Steam (Gamescope)
      Comment=Steam Big Picture in Gamescope
      Exec=env __GLX_VENDOR_LIBRARY_NAME=nvidia \
        ${lib.getExe pkgs.gamescope} -W 2560 -H 1440 -r 180 -c DP-1 -f --sdr-gamut-wideness 1 -e -- \
        ${lib.getExe pkgs.steam} -tenfoot
      Type=Application
      EOF
    '';

    passthru.providedSessions = [ "steam-gamescope" ];
  };
in
{
  options.apps.steam = {
    enable = lib.mkEnableOption "Steam support";
  };
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };

    environment.systemPackages = [
      pkgs.mangohud
      pkgs.gamescope-wsi
      pkgs.protonup-qt
    ];

    programs.gamemode.enable = true;

    services.displayManager.sessionPackages = [
      steamGamescopeSession
    ];
  };
}
