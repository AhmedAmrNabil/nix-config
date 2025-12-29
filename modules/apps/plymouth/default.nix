{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.apps.plymouth;
in
{
  options.apps.plymouth = {
    enable = lib.mkEnableOption "Plymouth with themes";
  };
  config = lib.mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      theme = "breeze";
      logo = "${pkgs.nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake-white.png";
      extraConfig = ''
        DeviceScale = 1;
      '';
    };

    boot.kernelParams = [
      "quiet"
      "splash"
    ];
  };
}
