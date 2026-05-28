{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.core.fonts;

  arabicFont = "Noto Naskh Arabic";
  emojiFont = "Noto Color Emoji";

  mkArabicMatch = target: ''
    <match target="pattern">
            <test name="lang" compare="contains">
                <string>ar</string>
            </test>
            <test qual="any" name="family">
                <string>${target}</string>
            </test>
            <edit name="family" mode="prepend" binding="strong">
                <string>${arabicFont}</string>
            </edit>
        </match>
  '';
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
    ];

    # Optional: Enable fontconfig tweaks
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "JetBrains Mono nerd font"
          "Noto Sans"
          arabicFont
          emojiFont
        ];
        sansSerif = [
          "Noto Sans Display"
          "Segoe UI"
          arabicFont
          emojiFont
        ];
        serif = [
          "Noto Serif"
          "Segoe UI"
          arabicFont
          emojiFont
        ];
      };
      subpixel.rgba = "rgb";
      hinting = {
        enable = true;
        style = "slight";
      };
      antialias = true;
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
            ${mkArabicMatch "sans-serif"}
            ${mkArabicMatch "serif"}
            ${mkArabicMatch "monospace"}
        </fontconfig>
      '';
    };

  };
}
