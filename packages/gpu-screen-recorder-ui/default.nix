{
  lib,
  stdenv,
  fetchgit,
  meson,
  ninja,
  wayland-scanner,
  wayland,
  wrapperDir ? "/run/wrappers/bin",
  makeWrapper,
  gitUpdater,
  pkg-config,
  gpu-screen-recorder,
  libdrm,
  libpulseaudio,
  libXrender,
  libX11,
  libXrandr,
  libXcomposite,
  libXi,
  libXcursor,
  libglvnd,
}:

stdenv.mkDerivation rec {
  pname = "gpu-screen-recorder-ui";
  version = "1.9.0";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-ui";
    tag = version;
    hash = "sha256-JyaBR/UCCQXrSM7gsqSQc/v+vFoqE6ygqsLqXUHVTJk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libX11
    libXrender
    libXrandr
    libXcomposite
    libXi
    libXcursor
    libglvnd
    libdrm
    libpulseaudio
    wayland
    wayland-scanner
  ];

  mesonFlags = [
    # will enable systemd in the module later
    (lib.mesonBool "systemd" false)
    (lib.mesonBool "capabilities" false)
  ];

  postInstall =
    let
      gpu-screen-recorder-wrapped = gpu-screen-recorder.override {
        inherit wrapperDir;
      };
    in
    ''
      wrapProgram "$out/bin/${meta.mainProgram}" \
        --prefix PATH : "${wrapperDir}" \
        --suffix PATH : "${
          lib.makeBinPath [
            gpu-screen-recorder-wrapped
          ]
        }" \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            libglvnd
            libdrm
            libX11
          ]
        }"
    '';

  passthru.updateScript = gitUpdater {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-ui";
  };

  meta = {
    description = "A fullscreen overlay UI for GPU Screen Recorder in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-ui/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      AhmedAmrNabil
    ];
    mainProgram = "gsr-ui";
  };
}
