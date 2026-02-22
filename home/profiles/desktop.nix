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
    alacritty.enable = true;
    cava.enable = true;
    foot.enable = true;
    only-office.enable = true;
    open-tablet-driver.enable = true;
    rofi.enable = true;
    spotify.enable = true;
    vscode.enable = true;
  };

  home.packages =
    with pkgs;
    [
      xournalpp
      vlc
      localsend
      transmission_4-qt
      blender
      teams-for-linux
      postman
      devenv
      avalonia-ilspy
      usbutils
      obsidian
      arduino-ide
    ]
    ++ (with pkgsUnstable; [
      antigravity
      (discord.override {
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
