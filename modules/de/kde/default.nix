{
  pkgs,
  ...
}:
{

  # KDE stuff
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    xserver.enable = true;
  };
  security.polkit.enable = true;

  environment.systemPackages = with pkgs.kdePackages; [
    sddm-kcm # Configuration module for SDDM
    partitionmanager # Optional: Manage the disk devices, partitions and file systems on your computer
  ];
}
