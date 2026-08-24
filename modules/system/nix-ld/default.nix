{
  flake.nixosModules.nix-ld =
    {
      pkgsUnstable,
      ...
    }:
    {
      programs.nix-ld = {
        enable = true;
        libraries = with pkgsUnstable; [
          stdenv.cc.cc.lib
          cudaPackages.cudatoolkit
          cudaPackages.cudnn
          libGL
          zlib
        ];
      };
    };
}
