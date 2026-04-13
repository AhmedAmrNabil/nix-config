{
  config,
  lib,
  gitConfig,
  pkgsUnstable,
  ...
}:
let
  cfg = config.apps.git;
in
{
  options.apps.git = {
    enable = lib.mkEnableOption "Git config management";
  };
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgsUnstable.git;
      settings = {
        alias = {
          ci = "commit";
          co = "checkout";
          st = "status";
          br = "branch";
          lg = "log --graph --oneline --all";
          aa = "add .";
          cm = "commit -m";
          amend = "commit --amend --no-edit";
          undo = "reset --soft HEAD~1";
        };
        user = {
          name = gitConfig.userName;
          email = gitConfig.userEmail;
        };
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
      lfs.enable = true;
    };
  };
}
