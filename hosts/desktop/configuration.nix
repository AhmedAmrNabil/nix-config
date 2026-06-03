# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  username,
  ...
}:
{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  # --------- Modules ------------------
  apps = {
    docker = {
      enable = true;
      storageDriver = "overlay2";
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
    # virt-manager.enable = true;
  };

  core = {
    audio.enable = true;
    boot.enable = true;
    fonts.enable = true;
    hardware.ddcci.enable = false;
    hardware.nvidia.enable = true;
    kernel.enable = true;
    nix-cfg.enable = true;
    nix-ld.enable = true;
    users.enable = true;
  };

  de.kde = {
    enable = true;
    autoLogin = true;
  };

  de.hyprland.enable = true;

  # --------- System configuration ------------------

  networking.hostName = "desktop-nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # disable unused services to speed up boot time
  systemd.services.Networkmanager-wait-online.enable = false;
  services.fwupd.enable = false;
  networking.modemmanager.enable = false;

  # Open port 5432 in firewall for PostgreSQL
  # networking.firewall.allowedTCPPorts = [ 5432 ];

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
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
    distrobox
    scrcpy
    mangohud
    (pkgs.writeShellScriptBin "mangohud-nvidia" ''
      export LD_PRELOAD=/run/opengl-driver/lib/libnvidia-ml.so.1
      exec ${pkgs.mangohud}/bin/mangohud "$@"
    '')
    deskflow
    android-tools
  ];

  # this is out of place but it is the only way to disable the annoying security warning when launching edge with custom flags
  environment.etc."opt/edge/policies/managed/policies.json".text = builtins.toJSON {
    CommandLineFlagSecurityWarningsEnabled = false;
  };

  # Enable platformio udev rules for esp32 development
  services.udev.packages = [
    pkgs.platformio-core
    pkgs.openocd
  ];

  # Enable local time synchronization
  # to prevent issues with dual booting Windows
  time.hardwareClockInLocalTime = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # serve /nix/store to laptop

  # services.nix-serve = {
  #   enable = true;
  #   secretKeyFile = "/var/cache-priv-key.pem";
  # };

  networking.firewall.allowedTCPPorts = [
    24800 # deskflow
    25565 # minecraft
    80 # http
    443 # https
  ];
  # fix /nix/store too many open files issue with nix-serve
  systemd.services.nix-serve.serviceConfig.LimitNOFILE = 65536;
  systemd.services.nix-serve.serviceConfig.Environment = "HOME=/home/${username}";

  networking.firewall.allowedUDPPorts = [
    53 # dns
    67 # dhcp
    24800 # deskflow
    25565 # minecraft
  ];

  # add zstd compression to file systems
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [
      "compress=zstd"
      "noatime"
    ];
    "/persist".options = [ "compress=zstd" ];
    "/swap".options = [ "noatime" ];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 16384; # 16GB in MB
    }
  ];

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
