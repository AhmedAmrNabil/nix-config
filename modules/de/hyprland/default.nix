{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.hyprland =
    { pkgs, ... }:
    let
      hyprlandPackages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
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

  flake.homeModules.hyprland =
    {
      pkgs,
      pkgsUnstable,
      config,
      ...
    }:
    {
      xdg.configFile."hypr/hyprland.lua".source = config.lib.utils.mkMutableSymlink ./hyprland.lua;

      xdg.configFile."hypr/config" = {
        source = config.lib.utils.mkMutableSymlink ./config;
        recursive = true;
      };

      services.hyprpaper = {
        enable = false;
        package = pkgsUnstable.hyprpaper;
        settings = {
          wallpaper = [
            {
              monitor = "DP-1";
              path = "${config.home.homeDirectory}/Pictures/wallpapers/pale-mountains.jpg";
              fit_mode = "cover";
            }
            {
              monitor = "DP-2";
              path = "${config.home.homeDirectory}/Pictures/wallpapers/pale-mountains.jpg";
              fit_mode = "cover";
            }
          ];
        };
      };

      imports = [
        self.homeModules.swaync
        self.homeModules.waybar
      ];

      programs.hyprlock.enable = true;

      home.packages = with pkgs; [
        playerctl
        grim
        slurp
      ];
    };
}
