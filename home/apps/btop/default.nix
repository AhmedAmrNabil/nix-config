{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.apps.btop;
  catppuccinBtop = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/catppuccin_mocha.theme";
    hash = "sha256-THRpq5vaKCwf9gaso3ycC4TNDLZtBB5Ofh/tOXkfRkQ=";
  };
in
{
  options.apps.btop = {
    enable = lib.mkEnableOption "btop with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.btop = {
      enable = true;
      package = pkgs.btop-cuda;
      settings = {
        color_theme = "${config.home.homeDirectory}/.config/btop/themes/catppuccin.theme";
        shown_boxes = "cpu mem net proc gpu0";
      };
      themes.catppuccin = builtins.readFile "${catppuccinBtop}";
    };
  };
}
