{
  flake.nixosModules.podman =
    {
      username,
      ...
    }:
    {
      virtualisation = {
        containers.enable = true;
        podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
        };
      };

      users.users.${username}.extraGroups = [ "podman" ];
    };
}
