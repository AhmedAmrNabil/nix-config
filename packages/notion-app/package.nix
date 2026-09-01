{
  lib,
  stdenv,
  fetchurl,
  p7zip,
  ast-grep,
  asar,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  electron_41,
  autoPatchelfHook,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  python3,
}:

let
  electron = electron_41;
  trayIcon = ./notion.png;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "notion-app";
  version = "7.31.3";

  nativeBuildInputs = [
    p7zip
    ast-grep
    asar
    makeWrapper
    copyDesktopItems
    autoPatchelfHook
    pnpm
    nodejs
    pnpmConfigHook
    python3
  ];

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./patches/better-sqlite3.patch
      ./package.json
      ./pnpm-lock.yaml
      ./pnpm-workspace.yaml
    ];
  };

  notionSetup = fetchurl {
    name = "notion";
    url = "https://desktop-release.notion-static.com/Notion%20Setup%20${finalAttrs.version}.exe";
    hash = "sha256-WJ3avn/fFi7h7z9ZAFkp4xuWFZtVP9VVevPC3SCPKwk=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-wuJUMrJx9dJ1rZPeOlZbDavURb7l6ioBpC4NNuzUXJk=";
    fetcherVersion = 3;
  };

  desktopItems = [
    (makeDesktopItem {
      name = "notion-app";
      type = "Application";
      desktopName = "Notion";
      genericName = "Online Document Editor";
      comment = "Your connected workspace for wiki, docs & projects";
      exec = "notion-app %U";
      icon = "notion";
      categories = [ "Office" ];
      mimeTypes = [
        "x-scheme-handler/notion"
      ];
    })
  ];

  buildPhase = ''
    runHook preBuild
    set -e

    export npm_config_nodedir="${electron.headers}"
    npx electron-rebuild \
      --version "${electron.version}" \
      --build-from-source \
      --force

    mkdir work

    pushd work

    # --- crack open the NSIS installer, same two-pass extraction as upstream PKGBUILD ---
    7z x '${finalAttrs.notionSetup}' '$PLUGINSDIR/app-64.7z' -y -bse0 -bso0 || true
    7z x './$PLUGINSDIR/app-64.7z' 'resources/app.asar' 'resources/app.asar.unpacked' -y -bse0 -bso0 || true

    asar extract resources/app.asar asar_patched
    [ -d resources/app.asar.unpacked ] && cp -r resources/app.asar.unpacked ./app.asar.unpacked

    install -Dm644 ../node_modules/better-sqlite3/build/Release/better_sqlite3.node \
      asar_patched/node_modules/better-sqlite3/build/Release/better_sqlite3.node

    install -Dm644 ${trayIcon} asar_patched/.webpack/main/trayIcon.png

    # --- ast-grep structural patches (identical intent to the PKGBUILD's sg_patch calls) ---
    index_js=asar_patched/.webpack/main/index.js
    sg_flags=(--lang javascript -U)
    sg_patch() { ast-grep run "''${sg_flags[@]}" -p "$1" -r "$2" "$index_js" >/dev/null 2>&1 || true; }
    sg_patch_select() { ast-grep run "''${sg_flags[@]}" --selector "$1" -p "$2" -r "$3" "$index_js" >/dev/null 2>&1 || true; }

    sg_patch \
      'this.tray.on("click",()=>{this.onClick()})' \
      'this.tray.setContextMenu(this.trayMenu),this.tray.on("click",()=>{this.onClick()})'

    sg_patch_select method_definition \
      'class X { getIcon(){ $$$BODY } }' \
      'getIcon(){return require("path").resolve(__dirname,"trayIcon.png");}'

    sg_patch \
      '$S.setUserAgent(`''${$S.getUserAgent()} WantsServiceWorker`)' \
      '$S.setUserAgent(`''${$S.getUserAgent().replace("Linux", "Windows")} WantsServiceWorker`)'

    sg_patch \
      'function $F(){const $$$P;if("darwin"===process.platform){$$$A}if("win32"===process.platform){$$$B}return!1}' \
      'function $F(){return!0}'

    sg_patch \
      'if("darwin"===process.platform)$MAC;else if("win32"===process.platform){const $UNINSTALL=$ARGS=>$ARGS.find($ARG=>"--uninstall"===$ARG);$$$B}' \
      'if("darwin"===process.platform)$MAC;else if("linux"===process.platform){const $UNINSTALL=$ARGS=>$ARGS.find($ARG=>"--uninstall"===$ARG);$$$B}'

    sg_patch \
      'function $F($ARG){const $EXT=$PATH.default.extname($ARG).toLowerCase();return!$ARG.startsWith("-")&&!$ARG.startsWith(`''${$CONFIG.default.protocol}:`)&&$EXT.length>0&&".exe"!==$EXT}' \
      'function $F($ARG){const $EXT=$PATH.default.extname($ARG).toLowerCase();return!$ARG.startsWith("-")&&!$ARG.startsWith(`''${$CONFIG.default.protocol}:`)&&$EXT.length>0&&".exe"!==$EXT&&".asar"!==$EXT}'

    sg_patch \
      '($$$PRE,function(){$$$INIT}(),0)' \
      '($$$PRE,function(){$$$INIT}())'

    sg_patch_select ternary_expression \
      '"win32"===process.platform?function($E,$T){$$$A}($E,$T):$ALT' \
      '"linux"===process.platform?function($E,$T){$$$A}($E,$T):$ALT'

    asar pack asar_patched app.asar --unpack '*.node'

    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/notion-app $out/bin $out/share/icons/hicolor/256x256/apps
    cp work/app.asar $out/lib/notion-app/
    [ -d work/app.asar.unpacked ] && cp -r work/app.asar.unpacked $out/lib/notion-app/

    install -Dm644 ${trayIcon} $out/share/icons/hicolor/256x256/apps/notion.png

    makeWrapper ${lib.getExe electron} $out/bin/notion-app \
      --inherit-argv0 \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags "$out/lib/notion-app/app.asar" \
      --add-flags "--no-sandbox"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Your connected workspace for wiki, docs & projects (repackaged Electron build)";
    homepage = "https://www.notion.so/desktop";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "notion-app";
  };
})
