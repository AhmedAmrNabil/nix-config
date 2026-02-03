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
    bat.enable = true;
    btop.enable = true;
    direnv.enable = true;
    eza.enable = true;
    fastfetch.enable = true;
    fish.enable = true;
    git.enable = true;
    micro.enable = true;
    starship.enable = true;
    zoxide.enable = true;
  };

  home.shellAliases = {
    restart-windows = "sudo systemctl reboot --boot-loader-entry=auto-windows";
  };

  home.packages = with pkgs; [
    nodejs_22
    pnpm
    nixfmt
    nixd
    gdu
    direnv
    fzf
    python3
    jq
  ];
}
