{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.apps.devenv;
in
{
  options.apps.devenv = {
    enable = lib.mkEnableOption "Devnev with shell integrations";
    enableFishIntegration = lib.mkEnableOption "Enable fish shell integration";
    enableBashIntegration = lib.mkEnableOption "Enable bash shell integration";
  };
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          devenv
        ];
      }
      (lib.mkIf cfg.enableFishIntegration {
        programs.fish.shellInit = ''
          devenv hook fish | source
        '';
      })
      (lib.mkIf cfg.enableBashIntegration {
        programs.bash.bashrcExtra = ''
          eval "$(devenv hook bash)"
        '';
      })
    ]
  );
}
