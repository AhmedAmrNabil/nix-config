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
        user = {
          name = gitConfig.userName;
          email = gitConfig.userEmail;
        };
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };
  };
}
