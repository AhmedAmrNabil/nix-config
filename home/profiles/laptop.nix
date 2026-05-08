{
  pkgs,
  pkgsUnstable,
  ...
}:
{
  imports = [
    ./shared.nix
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

  xdg.desktopEntries.microsoft-edge-autoscroll = {
    name = "Microsoft Edge (Autoscroll)";
    genericName = "Web Browser";
    exec = "microsoft-edge --enable-blink-features=MiddleClickAutoscroll %U";
    icon = "microsoft-edge";
    categories = [
      "Network"
      "WebBrowser"
    ];
  };
}
