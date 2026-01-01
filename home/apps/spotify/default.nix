{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.apps.spotify;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.apps.spotify = {
    enable = lib.mkEnableOption "Spotify with spicetify support";
  };
  config = lib.mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.text;
      customColorScheme = {
        accent = "89dceb";
        accent-active = "89dceb";
        accent-inactive = "1e1e2e";
        banner = "89dceb";
        border-active = "89dceb";
        border-inactive = "313244";
        header = "585b70";
        highlight = "585b70";
        main = "1e1e2e";
        notification = "89b4fa";
        notification-error = "f38ba8";
        subtext = "a6adc8";
        text = "cdd6f4";
      };
      enabledExtensions = [
        spicePkgs.extensions.adblock
        spicePkgs.extensions.shuffle
        spicePkgs.extensions.oneko
      ];
    };
  };
}
