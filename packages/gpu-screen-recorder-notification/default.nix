{
  lib,
  fetchgit,
  gitUpdater,
  libglvnd,
  makeWrapper,
  meson,
  ninja,
  pango,
  pkg-config,
  stdenv,
  wayland-scanner,
  wayland,
  gsettings-desktop-schemas,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "gpu-screen-recorder-notification";
  version = "1.2.3";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-notification";
    tag = version;
    hash = "sha256-tzyrI4B5JWiUOpaww/2oGAvYgNKGb63eap1NKy5uysU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libglvnd
    pango
    xorg.libX11
    xorg.libXrandr
    xorg.libXrender
    xorg.libXext
    wayland
    wayland-scanner
    gsettings-desktop-schemas
  ];

  strictDeps = true;

  mesonFlags = [
    "--buildtype=release"
    "-Dstrip=true"
  ];

  postInstall = ''
    wrapProgram "$out/bin/${meta.mainProgram}" \
      --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
  '';

  passthru.updateScript = gitUpdater {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-notification";
  };

  meta = {
    description = "Notification in the style of ShadowPlay.";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-notification";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      AhmedAmrNabil
    ];
    mainProgram = "gsr-notify";
  };
}
