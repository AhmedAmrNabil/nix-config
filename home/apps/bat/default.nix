{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.apps.bat;
  catppuccinMochaBat = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/bat/refs/heads/main/themes/Catppuccin%20Mocha.tmTheme";
    hash = "sha256-OVVm8IzrMBuTa5HAd2kO+U9662UbEhVT8gHJnCvUqnc=";
  };
in
{
  options.apps.bat = {
    enable = lib.mkEnableOption "Bat: cat alternative with extra config";
  };
  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      themes.catppuccin.src = catppuccinMochaBat;
      config.theme = "catppuccin";
    };
    home.shellAliases = {
      cat = "bat --paging=never -p";
    };
  };
}
