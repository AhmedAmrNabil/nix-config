{
  config,
  pkgs,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.nh;
in
{
  options.apps.nh = {
    enable = lib.mkEnableOption "nh with aliases";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.nh
    ];
    environment.sessionVariables = {
      NH_FLAKE = "/home/${username}/dotfiles";
    };
    environment.shellAliases = {
      nrs = "nh os switch";
      hrs = "nh home switch";
      wsl-nix-clean = "nh clean all --keep 1";
    };
  };
}
