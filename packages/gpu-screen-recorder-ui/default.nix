{
  lib,
  dbus,
  fetchgit,
  gitUpdater,
  gpu-screen-recorder,
  libcap,
  libdrm,
  libglvnd,
  libpulseaudio,
  linuxHeaders,
  makeWrapper,
  meson,
  ninja,
  pango,
  pkg-config,
  stdenv,
  wayland-scanner,
  wayland,
  gsettings-desktop-schemas,
  wrapperDir ? "/run/wrappers/bin",
  xorg,
  desktop-file-utils,
}:

stdenv.mkDerivation rec {
  pname = "gpu-screen-recorder-ui";
  version = "1.11.8";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-ui";
    tag = version;
    hash = "sha256-wDoeDiUAQHggJr3qaRoY5Q3Hw4JuuZ7Etw/Up6Ypp/o=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    desktop-file-utils
  ];

  buildInputs = [
    xorg.libX11
    xorg.libXrandr
    xorg.libXrender
    xorg.libXcomposite
    xorg.libXfixes
    xorg.libXext
    xorg.libXi
    xorg.libXcursor
    libglvnd
    libpulseaudio
    libdrm
    dbus
    linuxHeaders
    wayland
    wayland-scanner
    pango
    libcap
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    (lib.mesonBool "capabilities" false)
    "--buildtype=release"
  ];

  postInstall =
    let
      gpu-screen-recorder-wrapped = gpu-screen-recorder.override {
        inherit wrapperDir;
      };
    in
    ''
      wrapProgram "$out/bin/${meta.mainProgram}" \
        --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
        --prefix PATH : "${wrapperDir}" \
        --suffix PATH : "${lib.makeBinPath [ gpu-screen-recorder-wrapped ]}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libglvnd ]}"
    '';

  passthru.updateScript = gitUpdater {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-ui";
  };

  meta = {
    description = "A fullscreen overlay UI for GPU Screen Recorder in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-ui";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      AhmedAmrNabil
    ];
    mainProgram = "gsr-ui";
  };
}
