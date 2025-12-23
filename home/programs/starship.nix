{ config, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
    settings = {
      format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$python$character";
      directory = {
        style = "blue";
        truncation_length = 100;
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
}