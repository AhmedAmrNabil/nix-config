{
  pkgs,
  pkgsUnstable,
  ...
}:
{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./filesystems.nix
    ./vm.nix
  ];

  # --------- Modules ------------------
  apps = {
    docker = {
      enable = true;
      storageDriver = "overlay2";
      enableNvidia = true;
    };
    flydigictl.enable = true;
    gpu-screen-recorder = {
      enable = true;
      ui.enable = true;
    };
    nh.enable = true;
    obs.enable = true;
    open-tablet-driver.enable = true;
    plymouth.enable = false;
    steam.enable = true;
    tailscale.enable = true;
    virt-manager.enable = true;
  };

  core = {
    audio.enable = true;
    boot.enable = true;
    fonts.enable = true;
    hardware.ddcci.enable = true;
    hardware.nvidia.enable = true;
    kernel.enable = true;
    nix-cfg.enable = true;
    nix-ld.enable = false; # not needed for now
    users.enable = true;
  };

  de.kde = {
    enable = true;
    autoLogin = true;
  };

  de.hyprland.enable = true;

  # --------- Hostname and networking ------------------
  networking.hostName = "desktop-nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.modemmanager.enable = false; # disable unused, speeds up boot

  networking.firewall.allowedTCPPorts = [
    24800 # deskflow
    25565 # minecraft
    80 # http
    443 # https
  ];

  networking.firewall.allowedUDPPorts = [
    53 # dns
    67 # dhcp
    24800 # deskflow
    25565 # minecraft
  ];

  # loopback for ollama and open-webui
  networking.hosts = {
    "127.0.0.1" = [ "ollama.local" ];
  };

  hardware.bluetooth.enable = true;

  # --------- Timezone and clock ------------------
  time.timeZone = "Africa/Cairo";
  time.hardwareClockInLocalTime = true;

  # --------- Services ------------------
  services.openssh.enable = true;

  # Enable platformio udev rules for esp32 development
  services.udev.packages = [
    pkgs.platformio-core
    pkgs.openocd
  ];

  # Enable local llm
  services.ollama = {
    enable = true;
    package = pkgsUnstable.ollama-cuda;
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "65536"; # was 8192 — this is the context actually used via /v1
      OLLAMA_NUM_PARALLEL = "1"; # KV cache = num_ctx x num_parallel; avoids VRAM blowup
      OLLAMA_KV_CACHE_TYPE = "q8_0"; # halves KV-cache VRAM
    };
  };
  services.open-webui = {
    enable = true;
    port = 9000;
  };

  # enable nginx reverse proxy for open-webui
  services.nginx = {
    enable = true;
    virtualHosts."ollama.local".locations."/".proxyPass = "http://127.0.0.1:9000";
  };

  # disable some services that are not needed
  systemd.services.Networkmanager-wait-online.enable = false;
  services.fwupd.enable = false;

  # --------- Packages ------------------
  environment.systemPackages =
    with pkgs;
    [
      nano
      (lutris.override {
        extraPkgs =
          pkgs: with pkgs; [
            wineWow64Packages.stable
            winetricks
            gamemode
          ];
        extraLibraries = pkgs: [
          pkgs.gamemode
        ];
      })
      scrcpy
      mangohud
      deskflow
      android-tools
    ]
    ++ (with pkgsUnstable; [
      claude-code
    ]);

  # this is out of place but it is the only way to disable the annoying security warning when launching edge with custom flags
  environment.etc."opt/edge/policies/managed/policies.json".text = builtins.toJSON {
    CommandLineFlagSecurityWarningsEnabled = false;
  };

  # --------- Swap ------------------
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 16384; # 16GB in MB
    }
  ];

  system.stateVersion = "25.05";
}
