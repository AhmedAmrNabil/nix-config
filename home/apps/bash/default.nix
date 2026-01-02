{
  config,
  lib,
  ...
}:
let
  cfg = config.apps.bash;
in
{
  options.apps.bash = {
    enable = lib.mkEnableOption "Bash shell with custom configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      shellAliases = {
        clock = "tty-clock -tcDBC 4";
      };
    };
  };

}
