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
        wsl-nix-clean = "sudo nix-env --delete-generations old;sudo nix-collect-garbage -d";
      };
    };
  };

}
