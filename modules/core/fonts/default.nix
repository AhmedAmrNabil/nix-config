{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.core.fonts;
in
{
  options.core.fonts = {
    enable = lib.mkEnableOption "Enable default font packages and configurations";
  };

  config = lib.mkIf cfg.enable {

    fonts.packages = with pkgs; [
      noto-fonts
    ];

    # Optional: Enable fontconfig tweaks
    fonts.fontconfig = {
      enable = true;
    };
  };
}
