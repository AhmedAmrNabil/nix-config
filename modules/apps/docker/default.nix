{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.docker;
in
{
  options.apps.docker = {
    enable = lib.mkEnableOption "Docker support";
  };
  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };
    users.users."${username}".extraGroups = [ "docker" ];
  };
}
