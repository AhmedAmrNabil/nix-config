{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.apps.fish;

  catppuccin-fish = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fish";
    rev = "af622a6e247806f6260c00c6d261aa22680e5201";
    hash = "sha256-KD/sWXSXYVlV+n7ft4vKFYpIMBB3PSn6a6jz+ZIMZvQ=";
  };
in
{
  options.apps.fish = {
    enable = lib.mkEnableOption "Fish shell with custom configuration";
    loginShell = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Set fish as the login shell for the user.";
    };
  };
  config = lib.mkIf cfg.enable {

    programs.fish.enable = true;

    users.users."${username}" = lib.mkIf cfg.loginShell {
      shell = pkgs.fish;
    };

    home-manager.users.${username} = {
      programs.fish = {
        enable = true;
        shellAliases = {
          clock = "tty-clock -tcDBC 4";
          nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#(hostname)";
          wsl-nix-clean = "sudo nix-env --delete-generations old;sudo nix-collect-garbage -d";
        };
        shellInit = ''
          set -gx EDITOR micro
          set -gx VISUAL micro
          set -gx MICRO_TRUECOLOR 1
          fish_config theme choose "Catppuccin Mocha"
        '';
      };

      xdg.configFile."fish/themes/Catppuccin Mocha.theme".source = "${catppuccin-fish}/themes/Catppuccin Mocha.theme";
    };
  };

}
