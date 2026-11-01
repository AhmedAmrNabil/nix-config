{
  description = "CUDA dev shell";

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
      ];
      perSystem =
        { system, ... }:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          cuda_toolkit = pkgs.cudaPackages.cudatoolkit;
        in
        {
          devShells.default = pkgs.mkShell {
            packages = [ cuda_toolkit ];
            env = {
              CUDA_PATH = "${cuda_toolkit}";
              CUDA_HOME = "${cuda_toolkit}";
            };
            shellHook = ''
              export LD_LIBRARY_PATH="/run/opengl-driver/lib:$LD_LIBRARY_PATH"
            '';
          };
        };
    };
}
