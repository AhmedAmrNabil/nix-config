{
  lib,
  stdenv,
  fetchgit,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libglvnd,
  xorg,
  libdrm,
  libpulseaudio,
  gitUpdater,
  libcap,
  linuxHeaders,
  libGL,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "gpu-screen-recorder-ui";
  version = "1.8.3";

  src = fetchgit {
    url = "https://repo.dec05eba.com/${pname}";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    hash = "sha256-KB4N5DwzPKYhqIi+IlvkS6ZRh3ByFPCfF75Hg+na7Q8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-protocols
    makeWrapper
  ];
  buildInputs = [
    libcap
    linuxHeaders
    libglvnd
    libdrm
    libpulseaudio
    wayland
    wayland-scanner
    wayland.dev
    libGL
    xorg.libX11
    xorg.libXrandr
    xorg.libXrender
    xorg.libXcomposite
    xorg.libXfixes
    xorg.libXext
    xorg.libXi
    xorg.libXcursor
  ];

  strictDeps = true;

  mesonFlags = [
    (lib.mesonBool "systemd" true)
    (lib.mesonBool "capabilities" false)
  ];

  passthru.updateScript = gitUpdater {
    url = "https://repo.dec05eba.com/${pname}";
    rev-prefix = "";
  };

  postFixup = ''
    wrapProgram $out/bin/gsr-ui \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libglvnd
          libGL
          libdrm
          xorg.libX11
        ]
      }
  '';

  meta = with lib; {
    description = "A fullscreen overlay UI for GPU Screen Recorder in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-ui/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "gsr-ui";
  };

}
