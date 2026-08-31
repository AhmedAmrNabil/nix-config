{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook4,
  glib-networking,
  openssl,
  webkitgtk_4_1,
  libayatana-appindicator,
  alsa-lib,
  librsvg,
  gst_all_1,
  withTor ? true,
  withWhisper ? true,
  cmake,
  clang,
  vulkan-headers,
  shaderc,
  llvmPackages,
  vulkan-loader,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vector-chat";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "VectorPrivacy";
    repo = "Vector";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OT72notDnlBKa04Cg1b0ByY14oP7d2DyDj2hEZM4T10=";
  };

  patches = [
    ./0001-disable-updater.patch
  ];

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-RaBKediUP1ZeRyyqNQNIHf7sfd0iGIMWQtLW7GuwlwA=";
  };

  cargoHash = "sha256-sLhrMAxAhuw1iBsM/CnhB3VWnjV7CiaDHZQJFnb8ygA=";

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config

    wrapGAppsHook4

  ]
  # for whisper-rs with vulkan support
  ++ lib.optionals withWhisper [
    cmake
    clang
    vulkan-headers
    shaderc
  ];

  buildInputs = [
    glib-networking
    openssl
    webkitgtk_4_1
    libayatana-appindicator

    alsa-lib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    librsvg
  ]
  # vulkan runtime dependencies for whisper-rs
  ++ lib.optionals withWhisper [
    vulkan-loader
  ];

  env = lib.optionalAttrs withWhisper {
    # Required for whisper-rs bindgen
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
    # Vulkan support for whisper-rs
    VULKAN_SDK = "${vulkan-headers}";
  };

  buildNoDefaultFeatures = true;
  buildFeatures = (lib.optional withTor "tor") ++ (lib.optional withWhisper "whisper");

  # skipping docs tests
  cargoTestFlags = [
    "--tests"
  ];

  meta = {
    description = "Private, encrypted Nostr messenger";
    homepage = "https://github.com/VectorPrivacy/Vector";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "Vector";
  };
})
