{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.de.hyprland;
  hyprlandPackages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.de.hyprland = {
    enable = lib.mkEnableOption "Hyprland with UWSM and kwallet support";
  };
  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      # set the flake package
      package = hyprlandPackages.hyprland;
      # make sure to also set the portal package, so that they are in sync
      portalPackage = hyprlandPackages.xdg-desktop-portal-hyprland;
    };

    security.pam.services.sddm.kwallet = {
      enable = true;
      package = pkgs.kdePackages.kwallet-pam;
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "kwallet-init" ''
        ${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init
      '')
    ];
  };
}
