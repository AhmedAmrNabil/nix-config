{
  username,
  ...
}:

{

  imports = [
    ../shared.nix
    ../../modules
  ];

  apps.foot.enable = true;
  apps.vscode.enable = true;
  apps.cava.enable = true;
  apps.alacritty.enable = true;


  home-manager.users.${username} =
    { pkgs, inputs, ... }:
    {
      home.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        xournalpp
        (discord.override {
          withOpenASAR = true;
          withVencord = true;
        })
        vlc
        gdu
        direnv
        localsend
        fzf
        tree
      ];

      programs.spicetify =
        let
          spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        in
        {
          enable = true;
          theme = spicePkgs.themes.text;
          enabledExtensions = with spicePkgs.extensions; [
            adblock
            shuffle
            oneko
          ];
        };

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
