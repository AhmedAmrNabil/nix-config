{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.apps.virt-manager;
in
{
  options.apps.virt-manager = {
    enable = lib.mkEnableOption "Virtualization manager";
  };
  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    users.users.${username}.extraGroups = [ "libvirtd" ];

    # Networking
    environment.systemPackages = with pkgs; [
      dnsmasq
    ];
  };
}
