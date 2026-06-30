{
  lib,
  stdenvNoCC,
  fetchurl,
  p7zip,
}:

let
  version = "8.0.1";
  baseUrl = "https://devimages-cdn.apple.com/design/resources/download/";
in
stdenvNoCC.mkDerivation {
  pname = "apple-fonts";
  inherit version;

  srcs = [
    (fetchurl {
      url = "${baseUrl}SF-Pro.dmg";
      name = "SF-Pro-${version}.dmg";
      hash = "sha256-YxGk8IQ6TS5hagsFx3US0x0uqVBFnPUmzbW5CZageU8=";
    })
    (fetchurl {
      url = "${baseUrl}SF-Compact.dmg";
      name = "SF-Compact-${version}.dmg";
      hash = "sha256-/lF6UYS+KQ5m/om4tLbqGFSPztGuFTlJmnEmXjMXJJ8=";
    })
    (fetchurl {
      url = "${baseUrl}SF-Mono.dmg";
      name = "SF-Mono-${version}.dmg";
      hash = "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";
    })
    (fetchurl {
      url = "${baseUrl}NY.dmg";
      name = "NY-${version}.dmg";
      hash = "sha256-HC7ttFJswPMm+Lfql49aQzdWR2osjFYHJTdgjtuI+PQ=";
    })
  ];

  nativeBuildInputs = [ p7zip ];

  # Don't let stdenv unpack the DMGs automatically
  dontUnpack = true;

  installPhase = ''
    #bash
    runHook preInstall

    mkdir -p fonts licenses tmp

    for archive in $srcs; do
      # $srcs entries are store paths like /nix/store/...-SF-Pro-${version}.dmg
      echo "Processing $archive"
      7z e "$archive" -y -otmp/
      pushd tmp/

      7z x -txar *.pkg -y

      _fontname=$(grep -o -e "THE APPLE .* FONT" Resources/English.lproj/License.rtf | head -n 1)
      cp Resources/English.lproj/License.rtf "$PWD/../licenses/LICENSE.''${_fontname// /-}"

      pushd *.pkg/
      _fntver=$(grep -o -e ' version=".*">' PackageInfo)
      _fntver="''${_fntver:10:-2}"
      7z x Payload -y
      7z x 'Payload~' -y
      cp Library/Fonts/* "$PWD/../../fonts/"
      popd  # back to tmp/

      popd  # back to workdir
      rm -rf tmp/{*,.*} 2>/dev/null || true

      echo "Extracted $(basename $archive) version $_fntver"
    done

    rmdir tmp/

    install -Dm644 -t "$out/share/licenses/apple-fonts" licenses/*
    install -Dm644 -t "$out/share/fonts/apple-fonts" fonts/*

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fonts for Apple platforms, including San Francisco and New York typefaces";
    homepage = "https://developer.apple.com/fonts/";
    license = licenses.unfree; # Apple proprietary font license
    platforms = platforms.all;
    maintainers = [ ];
  };
}
