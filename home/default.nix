{ username, ... }: {
  imports = [
    ./apps
    ./de
    ./utils.nix
  ];

  # Required for standalone home-manager
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
