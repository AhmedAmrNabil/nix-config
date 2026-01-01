{
  ...
}:
{
  imports = [
    ../apps
  ];

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
}
