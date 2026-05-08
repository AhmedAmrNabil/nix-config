{
  config,
  pkgsUnstable,
  lib,
  ...
}:
let
  cfg = config.core.nix-ld;
in
{
  options.core.nix-ld = {
    enable = lib.mkEnableOption "Enable nix-ld configuration options";
  };
  config = lib.mkIf cfg.enable {
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
