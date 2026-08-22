{
  flake.nixosModules.docker =
    {
      pkgsUnstable,
      username,
      ...
    }:
    {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
        storageDriver = "overlay2";
        package = pkgsUnstable.docker; # Use the latest Docker package (as stable have a bug with buildx plugin)
      };
      users.users.${username}.extraGroups = [ "docker" ];
      hardware.nvidia-container-toolkit.enable = false;
    };
}
