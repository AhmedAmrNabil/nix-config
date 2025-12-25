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
  version = "1.8.3";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-ui";
    tag = version;
    hash = "sha256-KB4N5DwzPKYhqIi+IlvkS6ZRh3ByFPCfF75Hg+na7Q8=";
  };

  postPatch = ''
    substituteInPlace depends/mglpp/depends/mgl/src/gl.c \
      --replace-fail "libGL.so.1" "${lib.getLib libglvnd}/lib/libGL.so.1" \
      --replace-fail "libGLX.so.0" "${lib.getLib libglvnd}/lib/libGLX.so.0" \
      --replace-fail "libEGL.so.1" "${lib.getLib libglvnd}/lib/libEGL.so.1"

    substituteInPlace extra/gpu-screen-recorder-ui.service \
      --replace-fail "ExecStart=${meta.mainProgram}" "ExecStart=$out/bin/${meta.mainProgram}"
  '';

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
    (lib.mesonBool "systemd" true)
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
        }"
    '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "A fullscreen overlay UI for GPU Screen Recorder in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-ui/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "gsr-ui";
  };
}
