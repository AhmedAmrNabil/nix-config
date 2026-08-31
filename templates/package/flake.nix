{
  description = "A Simple nix package flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/c5c4a43b0e8056328ec4529f735cabdb8f1942bb";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem = { pkgs, ... }: {
        packages.default = pkgs.callPackage ./package.nix { };
      };
    };
}
