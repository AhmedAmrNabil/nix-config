# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  inputs,
  ...
}:
{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules
  ];

  # --------- Modules ------------------
  apps = {
    docker.enable = true;
    gpu-screen-recorder.enable = true;
    nh.enable = true;
    obs.enable = true;
    open-tablet-driver.enable = true;
    plymouth.enable = true;
    steam.enable = true;
    tailscale.enable = true;
    virt-manager.enable = true;
    flydigictl.enable = true;
  };

  core = {
    fonts.enable = true;
    nix-cfg.enable = true;
    users.enable = true;
    kernel.enable = true;
    boot.enable = true;
    hardware.nvidia.enable = true;
    hardware.ddcci.enable = true;
  };
  de.kde = {
    enable = true;
    autoLogin = true;
  };

  # services.vaderMapper.enable = true;

  # --------- System configuration ------------------

  networking.hostName = "desktop-nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Option 1: Open port 5432 in firewall for PostgreSQL
  networking.firewall.allowedTCPPorts = [ 5432 ];

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nano
    micro
    wayland-utils
    wl-clipboard
    microsoft-edge
    (lutris.override {
      extraPkgs =
        pkgs: with pkgs; [
          wineWowPackages.stable
          winetricks
          gamemode
        ];
      extraLibraries = pkgs: [
        pkgs.gamemode
      ];
    })
    distrobox
    inputs.winapps.packages.x86_64-linux.winapps
    inputs.winapps.packages.x86_64-linux.winapps-launcher
    freerdp
  ];

  programs.nix-ld = {
    enable = true;
  };

  # Enable local time synchronization
  # to prevent issues with dual booting Windows
  time.hardwareClockInLocalTime = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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

  # Mounting windows stuff:

  fileSystems."/home/btngana/hdd" = {
    device = "/dev/disk/by-uuid/01DAB93F51B44DA0";
    fsType = "ntfs";
    options = [
      "windows_names"
      "uid=1000"
      "gid=100"
      "umask=022"
      "big_writes"
      "nofail"
      "x-systemd.device-timeout=3s"
    ];
  };

  # Bind mount Videos and Downloads from hdd to home
  fileSystems."/home/btngana/Videos" = {
    device = "/home/btngana/hdd/Videos";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "/home/btngana/hdd" ];
  };

  fileSystems."/home/btngana/Downloads" = {
    device = "/home/btngana/hdd/Downloads";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "/home/btngana/hdd" ];
  };

  fileSystems."/home/btngana/crucial" = {
    device = "/dev/disk/by-uuid/7A5AE84D5AE807A9";
    fsType = "ntfs";
    options = [
      "windows_names"
      "uid=1000"
      "gid=100"
      "umask=000"
      "exec"
      "rw"
      "big_writes"
      "nofail"
      "x-systemd.device-timeout=3s"
    ];
  };

  fileSystems."/home/btngana/Games" = {
    device = "/home/btngana/crucial/Games";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "/home/btngana/crucial" ];
  };

  # Mounting windows partition for save files
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/54E4AE95E4AE793E";
    fsType = "ntfs";
    options = [
      "windows_names"
      "uid=1000"
      "gid=100"
      "umask=000"
      "exec"
      "rw"
      "big_writes"
      "nofail"
      "x-systemd.device-timeout=3s"
    ];
  };

  fileSystems."/home/btngana/wineprefixes/claire/drive_c/users/Public/Documents" = {
    device = "/mnt/windows/Users/Public/Documents";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "/mnt/windows" ];
  };

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
