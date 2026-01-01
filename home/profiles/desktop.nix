{
  pkgs,
  ...
}:
{
  imports = [
    ./shared.nix
  ];

  apps = {
    foot.enable = true;
    alacritty.enable = true;
    vscode.enable = true;
    cava.enable = true;
    spotify.enable = true;
  };

  home.packages = [
    pkgs.xournalpp
    (pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    pkgs.vlc
    pkgs.localsend
  ];

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

  xdg.desktopEntries.discord-autoscroll = {
    name = "Discord (Autoscroll)";
    genericName = "Chat Client";
    exec = "discord --enable-blink-features=MiddleClickAutoscroll %U";
    icon = "discord";
    categories = [
      "Network"
      "InstantMessaging"
    ];
  };
}
