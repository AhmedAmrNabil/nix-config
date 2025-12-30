{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.eza;
in
{
  options.apps.eza = {
    enable = lib.mkEnableOption "eza: A modern replacement for 'ls'";
    enableTree = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable eza tree alias.";
    };
  };
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home-manager.users.${username} =
          { pkgs, ... }:
          {
            programs.eza = {
              enable = true;
              icons = "always";
              extraOptions = [
                "--hyperlink"
                "--color=always"
                "--group-directories-first"
              ];
              enableFishIntegration = true;
              enableBashIntegration = true;
              git = true;
            };
            programs.fish.plugins = [
              {
                name = "eza-remove-default-ls-completion";
                src = pkgs.writeTextDir "completions/ls.fish" "";
              }
            ];
          };
      }
      (lib.mkIf cfg.enableTree {
        home-manager.users.${username} = {
          home.shellAliases = {
            tree = "eza --tree";
          };
        };
      })
    ]
  );
}
