{
  flake.nixosModules.nix-ld =
    {
      pkgsUnstable,
      config,
      ...
    }:
    {
      programs.nix-ld = {
        enable = true;
        libraries = with pkgsUnstable; [
          stdenv.cc.cc.lib
          glib
          openssl
          zlib

          # Graphics & dynamically matched NVIDIA driver
          libGL
          libepoxy
          config.hardware.nvidia.package # Always matches your kernel's nvidia

          # # Common Python / ML / OpenCV / Audio dependencies
          # util-linux
          # libxml2
          # xorg.libX11
          # xorg.libXext
          # xorg.libXrender
          # xorg.libICE
          # xorg.libSM
        ];
      };
    };
}
