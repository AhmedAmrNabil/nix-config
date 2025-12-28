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

    # profiles
    ../../home/profiles/desktop.nix
  ];

  # --------- Modules ------------------
  apps.gpu-screen-recorder.enable = true;
  apps.open-tablet-driver.enable = true;
  core = {
    fonts.enable = true;
    nix-cfg.enable = true;
    users.enable = true;
    kernel.enable = true;
  };
  de.kde.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "desktop-nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  hardware.bluetooth.enable = true;

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  environment.systemPackages = with pkgs; [
    nano
    micro

    wayland-utils
    wl-clipboard
    microsoft-edge
  ];

  # Enable local time synchronization
  # to prevent issues with dual booting Windows
  time.hardwareClockInLocalTime = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Nvidia stuff
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true; # see the note above
  hardware.nvidia.modesetting.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # add zstd compression to file systems
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [
      "compress=zstd"
      "noatime"
    ];
    "/persist".options = [ "compress=zstd" ];
  };

  # Mounting windows stuff:

  fileSystems."/d" = {
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

  fileSystems."/e" = {
    device = "/dev/disk/by-uuid/7A5AE84D5AE807A9";
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

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
