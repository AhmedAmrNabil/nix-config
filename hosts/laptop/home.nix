{
  pkgs,
  pkgsUnstable,
  ...
}:
{
  imports = [
    ../../home/shared.nix
  ];
  apps = {
    foot.enable = true;
    vscode.enable = true;
    cava.enable = true;
    spotify.enable = true;
    rofi.enable = true;
  };

  home.packages =
    with pkgs;
    [
      vlc
      localsend
      impala
    ]
    ++ (with pkgsUnstable; [
      arduino-ide
      arduino-cli
      platformio
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
        enableAutoscroll = true;
      })
    ]);

  xdg.desktopEntries.reboot-to-windows = {
    name = "Reboot to Windows";
    comment = "Restart the system and boot into Windows";
    icon = "${../../assets/windows-11.png}";
    exec = "pkexec systemctl reboot --boot-loader-entry=auto-windows";
    categories = [ "System" ];
    terminal = false;
  };
}
