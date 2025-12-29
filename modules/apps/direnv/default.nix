{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.direnv;
in
{
  options.apps.direnv = {
    enable = lib.mkEnableOption "Direnv with shell hooks";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
