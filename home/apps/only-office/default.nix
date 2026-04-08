{
  config,
  pkgs,
  lib,
  localPkgs,
  ...
}:
let
  cfg = config.apps.only-office;
in
{
  options.apps.only-office = {
    enable = lib.mkEnableOption "Only Office suite with extra fonts";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      onlyoffice-desktopeditors
      pkgs.vista-fonts
    ];
    home.activation.copyFontsLocalShare = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      fontDir="$HOME/.local/share/fonts"
      mkdir -p "$fontDir"

      install -m644 ${pkgs.corefonts}/share/fonts/truetype/* "$fontDir/"
      install -m644 ${pkgs.vista-fonts}/share/fonts/truetype/* "$fontDir/"
      install -m644 ${./cambria-math.ttf} "$fontDir/cambria-math.ttf"
    '';
  };
}
