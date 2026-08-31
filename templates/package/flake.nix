{
  description = "A Simple nix package flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/0dd31db7e6dbf9ce05697c4545f6fe01accec994";
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
