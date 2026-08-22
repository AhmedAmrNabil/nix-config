{
  flake.nixosModules.steam =
    {
      pkgs,
      ...
    }:
    {
      programs.gamemode.enable = true;
      programs.steam = {
        enable = true;
        package = pkgs.steam.override {
          extraPkgs = (
            pkgs: with pkgs; [
              gamemode
            ]
          );
        };
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
      };

      environment.systemPackages = with pkgs; [
        mangohud
        gamescope-wsi
        protonup-qt
      ];
    };
}
