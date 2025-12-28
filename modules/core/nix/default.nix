{
  config,
  lib,
  username,
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
    nix = {
      settings = {
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
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
        trusted-substituters = ["https://hyprland.cachix.org"];

        # enablke nix flakes
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowBroken = false;
      };
    };
  };
}
