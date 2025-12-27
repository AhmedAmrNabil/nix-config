{
  config,
  lib,
  username,
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
    home-manager.users.${username} =
      { ... }:
      {

        programs.bash = {
          enable = true;
          shellAliases = {
            ls = "eza --icons --hyperlink --color=always --group-directories-first";
            clock = "tty-clock -tcDBC 4";
            nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#$(hostname)";
            wsl-nix-clean = "sudo nix-env --delete-generations old;sudo nix-collect-garbage -d";
          };
          sessionVariables = {
            EDITOR = "micro";
            VISUAL = "micro";
            MICRO_TRUECOLOR = "1";
          };
        };
      };
  };

}
