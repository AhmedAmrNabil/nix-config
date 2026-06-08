# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
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

  # --------- System configuration ------------------

  networking.hostName = "desktop-nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # disable unused services to speed up boot time
  systemd.services.Networkmanager-wait-online.enable = false;
  services.fwupd.enable = false;
  networking.modemmanager.enable = false;

  time.timeZone = "Africa/Cairo";
  time.hardwareClockInLocalTime = true;

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

  services.openssh.enable = true;

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

  # serve /nix/store to laptop

  # services.nix-serve = {
  #   enable = true;
  #   secretKeyFile = "/var/cache-priv-key.pem";
  # };

  # fix /nix/store too many open files issue with nix-serve
  # systemd.services.nix-serve.serviceConfig.LimitNOFILE = 65536;
  # systemd.services.nix-serve.serviceConfig.Environment = "HOME=/home/${username}";

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

  system.stateVersion = "25.05";
}
