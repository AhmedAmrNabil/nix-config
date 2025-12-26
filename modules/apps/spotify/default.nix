{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.spotify;
in
{
  options.apps.spotify = {
    enable = lib.mkEnableOption "Spotify with spicetify support";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username}.imports = [
      ./home.nix
    ];
  };
}
