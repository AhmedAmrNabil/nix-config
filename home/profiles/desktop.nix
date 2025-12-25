{
  config,
  lib,
  pkgs,
  inputs,
  localPkgs,
  hilorioze,
  system,
  ...
}:

{
  imports = [
    ../shared.nix
    ../fonts.nix
    ../programs/foot.nix
    ../programs/vscode.nix
    ../programs/cava.nix
    ../programs/alacritty.nix
    ../programs/open-tablet-driver.nix
    inputs.spicetify-nix.homeManagerModules.default
  ];

  xdg.enable = true;

  # Desktop/laptop need fontconfig and GUI-focused extras
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    xournalpp
    # localPkgs.gpu-screen-recorder-ui
    # localPkgs.gpu-screen-recorder-notification
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    hilorioze.packages.${system}.gpu-screen-recorder-ui
    hilorioze.packages.${system}.gpu-screen-recorder-notification
    vlc
    gdu
    direnv
    localsend
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

}
