{
  description = "A Simple nix package flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/a7868a727837f3c09cee2ce0ca671c76b1589fed";
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
