{
  lib,
  inputs,
  ...
}:
{
  flake.nixosModules.nix-cfg = { username, ... }: {
    nix.settings = {
      warn-dirty = false;
      use-xdg-base-directories = true;
      keep-going = true;
      trusted-users = [
        username
        "@wheel"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://noctalia.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://ahmed-amr.cachix.org"
        "https://ngi-forge.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "ahmed-amr.cachix.org-1:gwUGJSgbW4JiorIqExv1r9uujfyS5Blc8S6L34gxUl0="
        "ngi-forge.cachix.org-1:PK0qK+LhWt4GQVpUtPapyXWxJSM1GhtmPW6CRCoygz0="
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
