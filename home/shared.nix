{ config, lib, pkgs, inputs, localPkgs, ... }:

{
  imports = [
    ./programs/fish.nix
    ./programs/starship.nix
    ./programs/micro.nix
    ./programs/btop.nix
    ./programs/fastfetch.nix
    ./programs/foot.nix
  ];

  home.username = "btngana";
  home.homeDirectory = "/home/btngana";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    git
    nodejs_22
    pnpm
    eza
    nixfmt
    nixd
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

  home.stateVersion = "25.11";
}
