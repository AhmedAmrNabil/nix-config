# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  lib,
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
    docker = {
      enable = true;
      storageDriver = "overlay2";
    };
    # gpu-screen-recorder.enable = true;
    nh.enable = true;
    # obs.enable = true;
    open-tablet-driver.enable = true;
    plymouth.enable = true;
    tailscale.enable = true;
  };
  core = {
    fonts.enable = true;
    nix-cfg.enable = true;
    users.enable = true;
    kernel.enable = true;
    boot.enable = true;
  };
  de.kde = {
    enable = true;
    autoLogin = true;
  };

  # entries limit override
  boot.loader.systemd-boot.configurationLimit = lib.mkForce 1;

  networking.hostName = "laptop-nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

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

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  programs.system-config-printer.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.micro
    pkgs.git
    pkgs.efibootmgr
    pkgs.microsoft-edge
    pkgs.kdePackages.print-manager
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  zramSwap = {
    enable = true;
    memoryPercent = 50; # ~4 GB compressed
  };

   swapDevices = [{
    device = "/swapfile";
    size = 8 * 1024; # 8GB
  }];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ avrdude ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
