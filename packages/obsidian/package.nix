{
  stdenv,
  fetchurl,
  lib,
  makeWrapper,
  electron,
  makeDesktopItem,
  imagemagick,
  asar,
  autoPatchelfHook,
  writeScript,
  _7zz,
  commandLineArgs ? "",
  copyDesktopItems,
}:
let
  pname = "obsidian";
  version = "1.13.4";
  appname = "Obsidian";
  meta = {
    description = "Powerful knowledge base that works on top of a local folder of plain text Markdown files";
    homepage = "https://obsidian.md";
    downloadPage = "https://github.com/obsidianmd/obsidian-releases/releases";
    mainProgram = "obsidian";
    license = lib.licenses.obsidian;
    maintainers = with lib.maintainers; [
      conradmearns
      zaninime
      kashw2
      w-lfchen
      prince213
    ];

    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/obsidian-${version}.tar.gz";
      hash = "sha256-66wkn5SbaJSBn7tLxWV+yIkvAGzv7ZVdNKbB/+Ji8Ws=";
    };

    aarch64-linux = fetchurl {
      url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/obsidian-${version}-arm64.tar.gz";
      hash = "sha256-4tRNJjab0DXhrVj2MRMHP7eRtS9MJsziLO1jtJKnE24=";
    };

    aarch64-darwin = fetchurl {
      url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/Obsidian-${version}.dmg";
      hash = "sha256-6EuVlaul5QIhyX5D0+P0N0Fu379MSoTDeUYecPhU148=";
    };
  };

  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  desktopItem = makeDesktopItem {
    name = "obsidian";
    desktopName = "Obsidian";
    startupWMClass = "md.Obsidian";
    comment = "Knowledge base";
    icon = "obsidian";
    exec = "obsidian %u";
    categories = [ "Office" ];
    mimeTypes = [ "x-scheme-handler/obsidian" ];
  };

  linux = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      imagemagick
      asar
      copyDesktopItems
    ];

    installPhase = ''
      runHook preInstall

      # Mark Obsidian's app:// scheme `corsEnabled` to fix the internal PDF
      # viewer; see https://github.com/NixOS/nixpkgs/pull/525772 for details.
      # Remove once upstream registers the scheme with `corsEnabled`.
      asar extract resources/app.asar app-src
      substituteInPlace app-src/main.js \
        --replace-fail "supportFetchAPI: true," "supportFetchAPI: true, corsEnabled: true,"
      asar pack app-src resources/app.asar

      mkdir -p "$out/opt/obsidian"
      cp -a resources "$out/opt/obsidian/"

      mkdir -p $out/bin
      makeWrapper ${lib.getExe electron} $out/bin/obsidian \
        --inherit-argv0 \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --add-flags $out/opt/obsidian/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime=true --wayland-text-input-version=3}}" \
        --add-flags ${lib.escapeShellArg commandLineArgs}

      install -m 755 -D obsidian-cli $out/bin/obsidian-cli

      copyDesktopItems

      for size in 16 24 32 48 64 128 256 512; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        magick resources/icon.png -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/obsidian.png
      done

      runHook postInstall
    '';

    desktopItems = [ desktopItem ];

    passthru = {
      inherit srcs;
      updateScript = writeScript "updater" ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p curl jq common-updater-scripts
        set -eu -o pipefail
        latestVersion="$(curl -sS https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/desktop-releases.json | jq -r '.latestVersion')"
        for platform in ${toString meta.platforms}; do
          update-source-version obsidian "$latestVersion" --ignore-same-version --source-key=passthru.srcs.$platform
        done
      '';
    };
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      appname
      meta
      ;
    nativeBuildInputs = [
      makeWrapper
      _7zz
    ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out/{Applications,bin}
      cp -R ${appname}.app $out/Applications
      makeWrapper $out/Applications/${appname}.app/Contents/MacOS/${appname} $out/bin/obsidian
      makeWrapper $out/Applications/${appname}.app/Contents/MacOS/obsidian-cli $out/bin/obsidian-cli
      runHook postInstall
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
