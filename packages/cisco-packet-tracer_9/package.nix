{
  appimageTools,
  dpkg,
  lib,
  libpng,
  libxkbfile,
  makeWrapper,
  runCommand,
  requireFile,
  stdenvNoCC,
  xdg-utils,
  version ? "9.0.1",
}:
let
  appimage = stdenvNoCC.mkDerivation {
    pname = "cisco-packet-tracer-appimage";
    inherit version;

    src =
      let
        sources = {
          "9.0.0" = {
            name = "CiscoPacketTracer_900_Ubuntu_64bit.deb";
            hash = "sha256-3ZrA1Mf8N9y2j2J/18fm+m1CAMFEklJuVhi5vRcu2SA=";
          };
          "9.0.1" = {
            name = "CiscoPacketTracer_901_Ubuntu_64bit.deb";
            hash = "sha256-NoPdh+d5iFNyrpo1wabllNEvST5knnxpdAhynBRZR5s=";
          };
        };
      in
      requireFile {
        inherit (sources."${version}") name hash;
        url = "https://www.netacad.com/resources/lab-downloads";
      };

    nativeBuildInputs = [
      dpkg
    ];

    installPhase = ''
      runHook preInstall

      cp opt/pt/packettracer.AppImage $out

      runHook postInstall
    '';
  };

  # make the login window launch correctly
  xdgOpenWrapper =
    runCommand "xdg-open-sanitized"
      {
        nativeBuildInputs = [ makeWrapper ];
      }
      ''
        mkdir -p $out/bin
        makeWrapper ${xdg-utils}/bin/xdg-open $out/bin/xdg-open \
          --unset LD_LIBRARY_PATH
      '';
in
appimageTools.wrapType2 rec {
  pname = "cisco-packet-tracer";
  inherit version;

  src = appimage;

  extraPkgs = _: [
    libpng
    libxkbfile
    (lib.hiPrio xdgOpenWrapper)
  ];

  extraBwrapArgs = [
    # fixes launch on wayland when the user sets QT_QPA_PLATFORM=wayland:
    # "Fatal: This application failed to start because no Qt platform plugin could be initialized."
    "--setenv QT_QPA_PLATFORM xcb"

    # Fix theming issues
    "--setenv QT_QPA_PLATFORMTHEME gtk3"
    "--setenv GTK_THEME Adwaita"
    "--setenv XDG_CURRENT_DESKTOP GNOME"
  ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      mv $out/bin/${pname} $out/bin/packettracer9

      install -Dm444 ${contents}/CiscoPacketTracer-${version}.desktop $out/share/applications/cisco-packet-tracer-9.desktop
      install -Dm444 ${contents}/CiscoPacketTracerPtsa-${version}.desktop $out/share/applications/cisco-packet-tracer-ptsa-9.desktop
      substituteInPlace $out/share/applications/* \
        --replace-fail "Exec=@EXEC_PATH@" "Exec=packettracer9" \
        --replace-fail "Icon=app" "Icon=cisco-packet-tracer-9"

      install -Dm444 ${contents}/usr/share/icons/hicolor/48x48/apps/app.png $out/share/icons/hicolor/48x48/apps/cisco-packet-tracer-9.png
      cp -r ${contents}/usr/share/icons/gnome/48x48/mimetypes $out/share/icons/hicolor/48x48/

      for desktop in $out/share/applications/*.desktop; do
        sed -i '/^\[Desktop Entry\]/a StartupWMClass=PacketTracer' "$desktop"
      done
    '';

  meta = {
    description = "Network simulation tool from Cisco";
    homepage = "https://www.netacad.com/courses/packet-tracer";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      gepbird
    ];
    mainProgram = "packettracer9";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
