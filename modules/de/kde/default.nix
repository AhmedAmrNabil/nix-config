
{
  flake.nixosModules.kde =
    {
      pkgs,
      username,
      ...
    }:
    let
      inherit (pkgs) kdePackages;
    in
    {
      services = {
        desktopManager.plasma6.enable = true;
        displayManager.plasma-login-manager.enable = true;
        xserver.enable = true;
      };

      security.polkit.enable = true;
      powerManagement.enable = true;

      programs.kdeconnect.enable = true;

      environment.systemPackages = [
        kdePackages.sddm-kcm
        kdePackages.kdialog
        kdePackages.partitionmanager
        pkgs.unrar
      ];

      # Remove unused packages
      environment.plasma6.excludePackages = with kdePackages; [
        elisa
        kate
        okular
        khelpcenter
        kinfocenter
        qrca
      ];

      services.displayManager.autoLogin = {
        enable = true;
        user = username;
      };

      security.pam.services.${username}.kwallet = {
        enable = true;
        package = kdePackages.kwallet-pam;
      };
    };
}
