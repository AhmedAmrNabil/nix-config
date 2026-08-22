{
  flake.nixosModules.tailscale = {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--ssh" ]; # Enable Tailscale SSH
    };
  };
}
