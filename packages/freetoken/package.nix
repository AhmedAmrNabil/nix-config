{
  lib,
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "freetoken";
  version = "beta";

  src = fetchurl {
    url = "https://github.com/FlashML-org/FreeToken-Web/releases/download/${finalAttrs.version}/freetoken-desktop-x86_64.AppImage";
    hash = "sha256-FVO8V5ihh+ERhpnLA3YSZEnTCNECWX1K98zmfUgN6q0="; # Replace with actual hash
  };

  appimageContents = appimageTools.extract {
    inherit (finalAttrs) pname version src;
  };

  # Extra libraries needed at runtime if UI features fail to load
  extraPkgs =
    pkgs: with pkgs; [
      libepoxy
      gtk3
      cairo
      glib
    ];

  # Includes a .desktop entry and icon if extracted from the AppImage
  extraInstallCommands = ''
    # Install icons if present in extracted contents
    if [ -d "${finalAttrs.appimageContents}/usr/share/icons" ]; then
      mkdir -p $out/share/icons
      cp -r ${finalAttrs.appimageContents}/usr/share/icons/* $out/share/icons/
    fi

    # Install desktop entry if present in extracted contents
    if [ -d "${finalAttrs.appimageContents}/usr/share/applications" ]; then
      mkdir -p $out/share/applications
      cp -r ${finalAttrs.appimageContents}/usr/share/applications/* $out/share/applications/

      # Patch the Exec path in the .desktop file to point to the nix store binary
      substituteInPlace $out/share/applications/*.desktop \
        --replace-fail "Exec=freetoken-desktop" "Exec=$out/bin/${finalAttrs.pname}"
    fi
  '';

  meta = with lib; {
    description = "FreeToken Desktop Application";
    homepage = "https://github.com/FlashML-org/FreeToken-Web";
    license = licenses.mit; # Update if under a different license
    platforms = [ "x86_64-linux" ];
    mainProgram = "freetoken";
  };
})
