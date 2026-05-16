{
  config,
  pkgs,
  lib,
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

    xdg.configFile."hypr/hyprland.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/de/hyprland/hyprland.lua";
    };

    # to be called inside hyprland.lua to enable the wallet
    home.packages = [
      (pkgs.writeShellScriptBin "kwallet-init" ''
        ${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init >> ${config.home.homeDirectory}/dotfiles/home/de/hyprland/kwallet-pam.log 2>&1
      '')
    ];
  };
}
