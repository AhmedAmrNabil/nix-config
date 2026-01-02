{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.apps.fish;

  catppuccin-fish = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fish";
    rev = "af622a6e247806f6260c00c6d261aa22680e5201";
    hash = "sha256-KD/sWXSXYVlV+n7ft4vKFYpIMBB3PSn6a6jz+ZIMZvQ=";
  };
in
{
  options.apps.fish = {
    enable = lib.mkEnableOption "Fish shell with custom configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellAliases = {
        clock = "tty-clock -tcDBC 4";
      };
      shellInit = ''
        fish_config theme choose "Catppuccin Mocha"
      '';
    };

    xdg.configFile."fish/themes/Catppuccin Mocha.theme".source =
      "${catppuccin-fish}/themes/Catppuccin Mocha.theme";
  };
}
