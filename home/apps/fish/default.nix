{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.apps.fish;

  catppuccinFish = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/fish/refs/heads/main/themes/catppuccin-mocha.theme";
    hash = "sha256-hLXJH83AkaWcHpikaUGEGZQf5XMlG5rViO0Wb9tOyIw=";
  };
in
{
  options.apps.fish = {
    enable = lib.mkEnableOption "fish shell with custom configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellInit = ''
        fish_config theme choose "catppuccin"
      '';
    };

    xdg.configFile."fish/themes/catppuccin.theme".source = "${catppuccinFish}";
  };
}
