{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  wrapGAppsHook4,
  cairo,
  dbus,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  pango,
  just,
  sqlite,
  wayland,
  libxkbcommon,
  libGL,
  libx11,
  libxcursor,
  libxi,
  autoPatchelfHook,
  nix-update-script,
  cosmic-icons
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "open-scq30";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "Oppzippy";
    repo = "OpenSCQ30";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qzDP3h1N28AyUuRvTnLq11RddAqWamCjvsWRkwOfWFg=";
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
    wrapGAppsHook4
    just
    autoPatchelfHook
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
    sqlite
    libxkbcommon
  ];

  # Wayland and X11 libs are required at runtime since winit uses dlopen
  runtimeDependencies = [
    wayland
    libxkbcommon
    libGL
    libx11
    libxcursor
    libxi
  ];

  cargoHash = "sha256-KA5yT+YTNCk1Olr4o8rZ9YuT0FlDHuYsnzPeWBGicx4=";

  env.INSTALL_PREFIX = placeholder "out";

  # Requires headphones
  doCheck = false;

  postPatch = ''
    #bash
    patchShebangs ./gui/scripts ./cli/scripts ./scripts
  '';

  buildPhase = ''
    #bash
    just build-cli
    just build-gui
  '';

  installPhase = ''
    #bash
    just install ${placeholder "out"}
  '';

  postFixup = ''
    wrapProgram $out/bin/openscq30-gui \
      --prefix XDG_DATA_DIRS : "${cosmic-icons}/share"
  '';

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Cross platform application for controlling settings of Soundcore headphones";
    homepage = "https://github.com/Oppzippy/OpenSCQ30";
    changelog = "https://github.com/Oppzippy/OpenSCQ30/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mkg20001 ];
    mainProgram = "open-scq30";
  };
})
