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
    ./home/programs/fish.nix
    ./home/programs/starship.nix
    ./home/programs/foot.nix
    ./home/programs/micro.nix
    ./home/programs/btop.nix
    # ./home/programs/alactritty.nix
    ./home/programs/fastfetch.nix
    ./home/programs/cava.nix
    ./home/programs/vscode.nix
    inputs.spicetify-nix.homeManagerModules.default
  ];
  nixpkgs.config.allowUnfree = true;

  home.username = "btngana";
  home.homeDirectory = "/home/btngana";
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    git
    nodejs_22
    pnpm
    eza
    zoxide
    vscode
    nixfmt
    # localPkgs.spotify-adblock
    (discord.override {
      withOpenASAR = true; # can do this here too
      withVencord = true;
    })

  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "AhmedAmrNabil";
        email = "ahmedamr24680@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

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

  home.stateVersion = "25.11";

}
