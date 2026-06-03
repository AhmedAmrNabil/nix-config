{
  config,
  lib,
  ...
}:
let
  cfg = config.apps.zoxide;
in
{
  options.apps.zoxide = {
    enable = lib.mkEnableOption "Zoxide with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = config.programs.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      options = [ "--cmd cd" ];
    };
  };
}
