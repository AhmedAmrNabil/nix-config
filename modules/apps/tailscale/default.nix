{
  config,
  lib,
  ...
}:
let
  cfg = config.apps.tailscale;
in
{
  options.apps.tailscale = {
    enable = lib.mkEnableOption "Tailscale VPN client";
  };
  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--ssh" ]; # Enable Tailscale SSH
    };
  };
}
