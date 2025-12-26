{
  config,
  lib,
  pkgs,
  username,
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
    ];

    # Optional: Enable fontconfig tweaks
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "JetBrains Mono nerd font"
          "Noto Sans"
          "Noto Naskh Arabic"
        ];
        sansSerif = [
          "Noto Sans Display"
          "Segoe UI"
          "Noto Naskh Arabic"
        ];
        serif = [
          "Noto Serif"
          "Segoe UI"
          "Noto Naskh Arabic"
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
            <match target="pattern">
                <test name="lang" compare="contains">
                    <string>ar</string>
                </test>
                <test qual="any" name="family">
                    <string>sans-serif</string>
                </test>
                <edit name="family" mode="prepend" binding="strong">
                    <string>Noto Naskh Arabic</string>
                </edit>
            </match>

            <match target="pattern">
                <test name="lang" compare="contains">
                    <string>ar</string>
                </test>
                <test qual="any" name="family">
                    <string>serif</string>
                </test>
                <edit name="family" mode="prepend" binding="strong">
                    <string>Noto Naskh Arabic</string>
                </edit>
            </match>
        </fontconfig>
      '';
    };

  };
}
