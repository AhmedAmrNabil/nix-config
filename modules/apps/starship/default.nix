{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.starship;
in
{
  options.apps.starship = {
    enable = lib.mkEnableOption "Starship prompt with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { ... }:
      {
        programs.starship = {
          enable = true;
          enableFishIntegration = true;
          enableBashIntegration = true;
          enableTransience = true;
          settings = {
            format = "$username$hostname$shell$directory$git_branch$git_state$git_status$cmd_duration$fill$time$line_break$python$nix_shell$character";
            directory = {
              style = "blue";
              truncation_length = 100;
              read_only = " ";
            };
            fill = {
              symbol = " ";
            };
            time = {
              format = "[󱑍 $time]($style)";
              style = "bright-black";
              time_format = "%I:%M %p";
              use_12hr = true;
              disabled = false;
            };
            shell = {
              fish_indicator = "";
              bash_indicator = " ";
              style = "bright-black";
              format = "[$indicator]($style) ";
              disabled = false;
            };
            character = {
              success_symbol = "[❯](purple)";
              error_symbol = "[❯](red)";
              vimcmd_symbol = "[❮](green)";
            };
            git_branch = {
              format = "[$branch]($style)";
              style = "bright-black";
            };
            git_status = {
              format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
              style = "cyan";
              conflicted = "​";
              untracked = "​";
              modified = "​";
              staged = "​";
              renamed = "​";
              deleted = "​";
              stashed = "≡";
            };
            git_state = {
              format = "[$state( $progress_current/$progress_total)]($style) ";
              style = "bright-black";
            };
            cmd_duration = {
              format = "[$duration]($style) ";
              style = "yellow";
            };
            python = {
              format = "[$virtualenv]($style) ";
              style = "bright-black";
              detect_extensions = [ ];
              detect_files = [ ];
            };
            nix_shell = {
              format = "[$name]($style) ";
              style = "bright-black";
            };
            hostname = {
              ssh_symbol = "";
              style = "242";
              format = "[@$hostname]($style) ";
            };
            username = {
              format = "[$user]($style)";
              style_user = "242";
              style_root = "red";
            };
          };
        };

        programs.fish.functions.starship_transient_prompt_func = ''
          starship module character
        '';
      };
  };
}
