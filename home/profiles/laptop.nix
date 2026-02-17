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
    vscode.enable = true;
    cava.enable = true;
    spotify.enable = true;
  };

  home.packages = with pkgs; [
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    vlc
    localsend
    arduino-ide
    arduino-cli
    # platformio-core
    platformio
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
