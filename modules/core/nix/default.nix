{
  config,
  lib,
  username,
  inputs,
  ...
}:
let
  cfg = config.core.nix-cfg;
in
{
  options.core.nix-cfg = {
    enable = lib.mkEnableOption "Enable nix configuration options";
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      warn-dirty = false;
      use-xdg-base-directories = true;
      keep-going = true;
      trusted-users = [
        "${username}"
        "@wheel"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://cache.garnix.io"
        "https://noctalia.cachix.org" 
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];

      # enable nix flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    nix.optimise.automatic = true;
    nix.gc = {
      automatic = true;
      dates = "daily";
    };

    nix.registry = lib.mapAttrs (_: flake: { inherit flake; }) inputs;
  };
}
