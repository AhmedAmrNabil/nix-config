{
  config,
  lib,
  username,
  pkgsUnstable,
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
      package = pkgsUnstable.docker; # Use the latest Docker package (as stable have a bug with buildx plugin)
    };
    users.users."${username}".extraGroups = [ "docker" ];
  };
}
