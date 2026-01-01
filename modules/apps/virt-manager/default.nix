{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.apps.virt-manager;
in
{
  options.apps.virt-manager = {
    enable = mkEnableOption "Virtualization manager";
  };
  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    users.users.${username}.extraGroups = [ "libvirtd" ];

    environment.systemPackages = [
      pkgs.dnsmasq
    ];
  };
}
