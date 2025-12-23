# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      edk2-uefi-shell.enable = true;
      windows = {
        "windows-11" = {
          title = "Windows 11";
          efiDeviceHandle = "FS2";
          sortKey = "a_windows";
        };
      };
    };
    efi.canTouchEfiVariables = true;
  };

  # use the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  fonts.packages = with pkgs; [
    noto-fonts
  ];

  # Optional: Enable fontconfig tweaks
  fonts.fontconfig = {
    enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # KDE stuff
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };
  security.polkit.enable = true;

  # Enable OpenTabletDriver for drawing tablets
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  # Required by OpenTabletDriver
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
  boot.blacklistedKernelModules = [ "wacom" ];

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.btngana = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --icons --hyperlink --color=always --group-directories-first";
    };
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nano
    micro

    # KDE
    kdePackages.sddm-kcm # Configuration module for SDDM
    kdePackages.partitionmanager # Optional: Manage the disk devices, partitions and file systems on your computer

    wayland-utils # Wayland utilities
    wl-clipboard # Command-line copy/paste utilities for Wayland
    microsoft-edge
  ];

  # enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable local time synchronization
  # to prevent issues with dual booting Windows
  time.hardwareClockInLocalTime = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Nvidia stuff
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true; # see the note above
  hardware.nvidia.modesetting.enable = true;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
