{
  config,
  lib,
  username,
  pkgs,
  ...
}:
let
  cfg = config.apps.btop;
  catppuccin-btop = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "f437574b600f1c6d932627050b15ff5153b58fa3";
    hash = "sha256-mEGZwScVPWGu+Vbtddc/sJ+mNdD2kKienGZVUcTSl+c=";
  };
in
{
  options.apps.btop = {
    enable = lib.mkEnableOption "btop with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { config, ... }:
      {
        programs.btop = {
          enable = true;
          package = pkgs.btop-cuda;
          settings = {
            color_theme = "${config.home.homeDirectory}/.config/btop/themes/catppuccin_mocha.theme";
            shown_boxes = "cpu mem net proc gpu0";
          };
          themes = {
            catppuccin_mocha = builtins.readFile "${catppuccin-btop}/themes/catppuccin_mocha.theme";
          };
        };
      };
  };
}
