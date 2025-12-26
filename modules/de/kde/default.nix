{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.de.kde;
in
{
  options.de.kde = {
    enable = lib.mkEnableOption "KDE Plasma Desktop Environment";
  };

  config = lib.mkIf cfg.enable {

    # KDE stuff
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm.enable = true;
      displayManager.sddm.wayland.enable = true;
      xserver.enable = true;
    };
    security.polkit.enable = true;

    programs.kdeconnect.enable = true;
    environment.systemPackages = with pkgs.kdePackages; [
      sddm-kcm # Configuration module for SDDM
      partitionmanager # Optional: Manage the disk devices, partitions and file systems on your computer
    ];
  };
}
