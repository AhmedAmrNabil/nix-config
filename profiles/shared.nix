{
  ...
}:
{
  imports = [
    ../modules
  ];

  apps = {
    bash.enable = true;
    btop.enable = true;
    fastfetch.enable = true;
    fish = {
      enable = true;
      loginShell = true;
    };
    micro.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    git.enable = true;
  };
}
