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

  flake.homeModules.kde =
    {
      config,
      lib,
      ...
    }:
    {
      # fix kde app launcher not showing new applications added by home-manager rebuild
      home.activation = {
        kde-fix-icons = lib.hm.dag.entryAfter [ "installPackages" ] ''
          rm -rf ${config.home.homeDirectory}/.cache/ksycoca*
        '';
      };

      # fix laggy kde
      # see: https://github.com/NixOS/nixpkgs/issues/363068#issuecomment-5209282821
      xdg.dataFile."plasma/desktoptheme/default/translucent/colors".text = "";
    };
}
