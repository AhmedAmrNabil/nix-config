{
  config,
  pkgs,
  lib,
  username,
  ...
}:
let
  cfg = config.de.hyprland;
in
{
  options.de.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland with customizations";
  };
  config = lib.mkIf cfg.enable {
    # wayland.windowManager.hyprland.enable = true;
    # wayland.windowManager.hyprland.package = null;
    # wayland.windowManager.hyprland.portalPackage = null;

    xdg.configFile."hypr/hyprland.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/de/hyprland/hyprland.lua";
    };

    # to be called inside hyprland.lua to enable the wallet
    home.packages = [
      (pkgs.writeShellScriptBin "kwallet-init" ''
        exec ${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init
      '')
    ];
  };
}
