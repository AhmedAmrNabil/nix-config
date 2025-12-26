{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.zoxide;
in
{
  options.apps.zoxide = {
    enable = lib.mkEnableOption "Zoxide with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { ... }:
      {
        programs.zoxide = {
          enable = true;
          enableFishIntegration = true;
          options = [ "--cmd cd" ];
        };
      };
  };
}
