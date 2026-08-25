{ pkgs, ... }:
rec {
  spotify-adblock = pkgs.callPackage ./spotify-adblock/package.nix { };
  wps-fonts = pkgs.callPackage ./wps-fonts/package.nix { };
  flydigictl = pkgs.callPackage ./flydigictl/package.nix { };
  apple-fonts = pkgs.callPackage ./apple-fonts/package.nix { };
  claude-desktop = pkgs.callPackage ./claude-desktop/package.nix { };

  gpu-screen-recorder = pkgs.callPackage ./gpu-screen-recorder/package.nix { };
  gpu-screen-recorder-notification =
    pkgs.callPackage ./gpu-screen-recorder-notification/package.nix
      { };
  gpu-screen-recorder-ui = pkgs.callPackage ./gpu-screen-recorder-ui/package.nix {
    inherit gpu-screen-recorder-notification;
  };

  prismlauncher-9 = pkgs.callPackage ./prism-launcher-9/package.nix {
    jdks = [
      pkgs.jdk17
      pkgs.jdk25
    ];
  };
}
