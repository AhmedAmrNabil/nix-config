{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.alacritty;
in
{
  options.apps.alacritty = {
    enable = lib.mkEnableOption "Alacritty terminal emulator";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username}.imports = [
      ./home.nix
    ];
  };
}
