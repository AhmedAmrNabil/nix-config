{
  lib,
  stdenv,
  fetchgit,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-scanner,
  libglvnd,
  xorg,
  gitUpdater,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "gpu-screen-recorder-notification";
  version = "1.1.0";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-notification";
    tag = version;
    hash = "sha256-ODifZ046DEBNiGT3+S6pQyF8ekrb6LIHWton8nv1MBo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    libglvnd
    xorg.libX11
    xorg.libXrandr
    xorg.libXrender
    xorg.libXext
    wayland
    wayland-scanner
  ];

  strictDeps = true;

  postInstall = ''
    wrapProgram "$out/bin/${meta.mainProgram}" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libglvnd
        ]
      }"
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Notification in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-notification/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "gsr-notify";
  };
}
