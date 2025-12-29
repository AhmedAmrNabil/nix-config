{
  username,
  ...
}:

{

  imports = [
    ./shared.nix
  ];

  apps.foot.enable = true;
  apps.alacritty.enable = true;
  apps.vscode.enable = true;
  apps.cava.enable = true;
  apps.spotify.enable = true;
  apps.tailscale.enable = true;
  apps.obs.enable = true;
  apps.docker.enable = true;
  apps.steam.enable = true;
  apps.virt-manager.enable = true;

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        xournalpp
        (discord.override {
          withOpenASAR = true;
          withVencord = true;
        })
        vlc
        localsend
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

    };

}
