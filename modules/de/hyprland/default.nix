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
    enable = lib.mkEnableOption "Hyprland with customizations";
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
  };
}
