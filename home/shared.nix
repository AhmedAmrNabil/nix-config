{
  username,
  ...
}:

{
  imports = [
    ../modules
  ];
  apps.fish.enable = true;
  apps.starship.enable = true;
  apps.fastfetch.enable = true;
  apps.btop.enable = true;
  apps.zoxide.enable = true;
  apps.micro.enable = true;

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nodejs_22
        pnpm
        eza
        nixfmt
        nixd
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
      home.stateVersion = "25.11";
    };
}
