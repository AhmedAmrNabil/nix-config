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
          cudaPackages.cuda_nvcc
          cudaPackages.cudatoolkit
          glib
          libepoxy
          openssl
          linuxPackages.nvidia_x11
          libGL
          zlib
        ];
      };
    };
}
