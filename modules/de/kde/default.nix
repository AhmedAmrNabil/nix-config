{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  inherit (pkgs) kdePackages;
  cfg = config.de.kde;
in
{
  options.de.kde = {
    enable = lib.mkEnableOption "KDE Plasma Desktop Environment";

    autoLogin = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable automatic login for the KDE desktop environment.";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services = {
          desktopManager.plasma6.enable = true;
          displayManager.sddm = {
            enable = true;
            wayland.enable = true;
          };
          xserver.enable = true;
        };

        security.polkit.enable = true;
        powerManagement.enable = true;

        programs.kdeconnect.enable = true;

        environment.systemPackages = [
          kdePackages.sddm-kcm
          kdePackages.partitionmanager
        ];

        # Remove unused packages
        environment.plasma6.excludePackages = [
          kdePackages.elisa
          kdePackages.kate
          kdePackages.okular
          kdePackages.khelpcenter
          kdePackages.kinfocenter
        ];
      }

      # Conditional auto-login + kwallet PAM config
      (lib.mkIf cfg.autoLogin {
        services.displayManager.autoLogin = {
          enable = true;
          user = username;
        };

        security.pam.services.${username}.kwallet = {
          enable = true;
          package = kdePackages.kwallet-pam;
        };
      })
    ]
  );
}
