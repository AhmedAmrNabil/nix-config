{
  lib,
  stdenvNoCC,
  fetchurl,
  p7zip,
}:

let
  baseUrl = "https://devimages-cdn.apple.com/design/resources/download/";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "apple-fonts";
  version = "8.0.1";

  srcs = [
    (fetchurl {
      url = "${baseUrl}SF-Pro.dmg";
      name = "SF-Pro-${finalAttrs.version}.dmg";
      hash = "sha256-loqzuLH5LC2K9h6waA9cIiTE541ZuYa/AEUCp/wBKRg=";
    })
    (fetchurl {
      url = "${baseUrl}SF-Compact.dmg";
      name = "SF-Compact-${finalAttrs.version}.dmg";
      hash = "sha256-wdDjROut1m62LwP4I3hMzknxeH9WVj+wmPygH8VUE1w=";
    })
    (fetchurl {
      url = "${baseUrl}SF-Mono.dmg";
      name = "SF-Mono-${finalAttrs.version}.dmg";
      hash = "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";
    })
    (fetchurl {
      url = "${baseUrl}NY.dmg";
      name = "NY-${finalAttrs.version}.dmg";
      hash = "sha256-HC7ttFJswPMm+Lfql49aQzdWR2osjFYHJTdgjtuI+PQ=";
    })
  ];

  nativeBuildInputs = [ p7zip ];

  # Don't let stdenv unpack the DMGs automatically
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p fonts licenses tmp

    for archive in $srcs; do
      echo "Processing $archive"
      7z e "$archive" -y -otmp/
      pushd tmp/

      # The DMG yields a raw APFS image with the Xar pkg embedded in it
      7z x *_Apple_APFS -y

      _fontname=$(grep -o -e "THE APPLE .* FONT" Resources/English.lproj/License.rtf | head -n 1)
      cp Resources/English.lproj/License.rtf "$PWD/../licenses/LICENSE.''${_fontname// /-}"

      pushd *.pkg/
      7z x Payload -y
      7z x 'Payload~' -y
      cp Library/Fonts/* "$PWD/../../fonts/"
      popd  # back to tmp/

      popd  # back to workdir
      rm -rf tmp/{*,.*} 2>/dev/null || true

      echo "Extracted $(basename $archive)"
    done

    rmdir tmp/

    install -Dm644 -t "$out/share/licenses/apple-fonts" licenses/*
    install -Dm644 -t "$out/share/fonts/apple-fonts" fonts/*

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fonts for Apple platforms, including San Francisco and New York typefaces";
    homepage = "https://developer.apple.com/fonts";
    license = licenses.unfree; # Apple proprietary font license
    platforms = platforms.all;
    maintainers = with lib.maintainers; [ AhmedAmr ];

    # broken since latest update to the font on apple fonts, wont fix for now
    broken = true;
  };
})
