{
  lib,
  buildGoModule,
  installShellFiles,
  pkg-config,
  libusb1,
  fetchFromGitHub,
}:

let
  version = "0.0.1";
in
buildGoModule {
  pname = "flydigictl";
  inherit version;

  src = fetchFromGitHub {
    owner = "pipe01";
    repo = "flydigictl";
    rev = "refs/heads/master";
    hash = "sha256-wL4JRRtAUgFL3XrnQI1vZq7Nic/RFSjJhQllxCHznxU=";
  };

  vendorHash = "sha256-HPkLEAVPw+DH9IQTRfruwaPsGwFdf4OpV1PFzpxi6fo=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ libusb1 ];

  ldflags = [
    "-X"
    "github.com/pipe01/flydigictl/pkg/version.Version=${version}"
  ];

  # Build both binaries
  subPackages = [
    "cmd/flydigictl"
    "cmd/flydigid"
  ];

  postInstall = ''
    # Install D-Bus configuration
    install -Dm644 etc/flydigid.conf $out/share/dbus-1/system.d/flydigid.conf
    install -Dm644 etc/com.pipe01.flydigi.Gamepad.service $out/share/dbus-1/system-services/com.pipe01.flydigi.Gamepad.service

    # Install systemd service
    install -Dm644 etc/flydigid.service $out/lib/systemd/system/flydigid.service

    # Generate shell completions
    installShellCompletion --cmd flydigictl \
      --bash <($out/bin/flydigictl completion bash) \
      --fish <($out/bin/flydigictl completion fish) \
      --zsh <($out/bin/flydigictl completion zsh)
  '';

  patches = [ ./optional_dbus.patch ];

  postPatch = ''
    # change /usr/bin/flydigid in systemd service to $out/bin/flydigid
    substituteInPlace etc/flydigid.service \
      --replace-fail "ExecStart=/usr/bin/flydigid" "ExecStart=$out/bin/flydigid"
  '';

  meta = with lib; {
    description = "Utility for configuring Flydigi controllers";
    homepage = "https://github.com/pipe01/flydigictl";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
