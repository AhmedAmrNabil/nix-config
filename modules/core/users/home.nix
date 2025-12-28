{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_22
    pnpm
    eza
    nixfmt
    nixd
    gdu
    direnv
    fzf
    tree
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "AhmedAmrNabil";
        email = "ahmedamr24680@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };
  
}
