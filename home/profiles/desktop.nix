{
  config,
  lib,
  pkgs,
  inputs,
  localPkgs,
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
    localPkgs.gpu-screen-recorder-ui
    localPkgs.gpu-screen-recorder-notification
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })

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
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        shuffle
      ];
    };
}
