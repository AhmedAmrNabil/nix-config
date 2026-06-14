{
  home.file."mountfs.sh" = {
    source = ../../home/scripts/mountfs.sh;
    executable = true;
  };

  apps.bash.enable = true;
  apps.bat.enable = true;
  apps.eza.enable = true;
  apps.fastfetch.enable = true;
  apps.fish.enable = true;
  apps.micro.enable = true;
  apps.starship.enable = true;
  apps.zoxide.enable = true;
  apps.foot.enable = true;
}
