{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../apps
  ];

  # Required for standalone home-manager
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  apps = {
    bash.enable = true;
    btop.enable = true;
    direnv.enable = true;
    fastfetch.enable = true;
    fish.enable = true;
    eza.enable = true;
    micro.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    git.enable = true;
  };

  home.packages = with pkgs; [
    nodejs_22
    pnpm
    nixfmt
    nixd
    gdu
    direnv
    fzf
  ];
}
