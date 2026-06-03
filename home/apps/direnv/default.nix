{
  config,
  lib,
  ...
}:
let
  cfg = config.apps.direnv;
in
{
  options.apps.direnv = {
    enable = lib.mkEnableOption "Direnv with shell hooks";
  };
  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = config.programs.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      nix-direnv.enable = true;
    };
  };
}
