{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.btop;
in
{
  options.apps.btop = {
    enable = lib.mkEnableOption "btop with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      imports = [ ./home.nix ];
    };
  };
}
