# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{
  pkgs ? import <nixpkgs> { },
  libnbtplusplus,
  ...
}:

rec {
  # # The `lib`, `modules`, and `overlay` names are special
  # lib = import ./lib { inherit pkgs; }; # functions
  # modules = import ./modules; # NixOS modules
  # overlays = import ./overlays; # nixpkgs overlays

  spotify-adblock = pkgs.callPackage ./spotify-adblock/package.nix { };  
  wps-fonts = pkgs.callPackage ./wps-fonts/package.nix { };
  flydigictl = pkgs.callPackage ./flydigictl/package.nix { };
  apple-fonts = pkgs.callPackage ./apple-fonts/package.nix { };
  
  gpu-screen-recorder-notification = pkgs.callPackage ./gpu-screen-recorder-notification/package.nix { };
  gpu-screen-recorder-ui = pkgs.callPackage ./gpu-screen-recorder-ui/package.nix {
    inherit gpu-screen-recorder-notification;
  };
  
  prismlauncher-9-unwrapped = pkgs.callPackage ./prism-launcher-9/unwrapped.nix {
    inherit libnbtplusplus;
  };
  prismlauncher-9 = pkgs.callPackage ./prism-launcher-9/wrapper.nix {
    prismlauncher-unwrapped = prismlauncher-9-unwrapped;
    jdks = [ pkgs.jdk17 pkgs.jdk25 ];
  };
}
