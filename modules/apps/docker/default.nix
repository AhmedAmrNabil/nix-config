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
    storageDriver = lib.mkOption {
      type = lib.types.str;
      default = "btrfs";
      description = "The storage driver to use for Docker.";
    };
  };
  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      storageDriver = cfg.storageDriver;
    };
    users.users."${username}".extraGroups = [ "docker" ];
  };
}
