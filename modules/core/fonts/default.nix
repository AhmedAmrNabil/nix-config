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
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
      vista-fonts
      apple-fonts
    ];

    # Optional: Enable fontconfig tweaks
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "JetBrains Mono nerd font"
          "Noto Sans Mono"
          "Noto Naskh Arabic"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans Display"
          "Segoe UI"
          "Noto Naskh Arabic"
          "Noto Color Emoji"
        ];
        serif = [
          "Noto Serif"
          "Segoe UI"
          "Noto Naskh Arabic"
          "Noto Color Emoji"
        ];
      };
      subpixel.rgba = "rgb";
      hinting = {
        enable = true;
        style = "slight";
      };
      antialias = true;
      localConf = builtins.readFile ./90-arabic.conf;
    };

  };
}
