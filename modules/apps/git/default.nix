{
  flake.homeModules.git = { pkgsUnstable, ... }: {
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
          name = "AhmedAmrNabil";
          email = "ahmedamr24680@gmail.com";
        };
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
      lfs.enable = true;
    };
  };
}
