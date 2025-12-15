{config, lib, pkgs, ...}:

{

  home.username = "btngana";
  home.homeDirectory = "/home/btngana";
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    git
    nodejs_22
    pnpm
    starship
	  eza
    fastfetch
    vscode
    spotify
    (discord.override {
          withOpenASAR = true; # can do this here too
          withVencord = true;
    })

  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "AhmedAmrNabil";
        email = "ahmedamr24680@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };


  home.stateVersion = "25.11";

}
