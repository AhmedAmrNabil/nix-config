{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.de.hyprland;
in
{
  options.de.hyprland = {
    enable = lib.mkEnableOption "Hyprland with customizations";
  };
  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      # set the flake package
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # make sure to also set the portal package, so that they are in sync
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };
}
