{ self, ... }: {
  flake.nixosModules.laptop-nixos =
    {
      pkgs,
      lib,
      ...
    }:
    {

      # entries limit override
      boot.loader.systemd-boot.configurationLimit = lib.mkForce 1;

      networking.hostName = "laptop-nixos";

      # Enable networking
      networking.networkmanager.enable = true;
      networking.firewall.allowedTCPPorts = [
        5000
        5005
      ];

      # hotspot
      services.create_ap = {
        enable = true;
        settings = {
          INTERNET_IFACE = "wlp0s20f3";
          WIFI_IFACE = "wlp0s20f3";
          SSID = "Mostafa";
          PASSPHRASE = "12345678";
          CHANNEL = "2";
        };
      };

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

      services.printing.enable = true;
      services.printing.drivers = [ pkgs.hplipWithPlugin ];
      programs.system-config-printer.enable = true;

      environment.systemPackages = with pkgs; [
        micro
        git
        efibootmgr
        microsoft-edge
        kdePackages.print-manager
      ];

      hardware.bluetooth.enable = true;

      # this is out of place but it is the only way to disable the annoying security warning when launching edge with custom flags
      environment.etc."opt/edge/policies/managed/policies.json".text = builtins.toJSON {
        CommandLineFlagSecurityWarningsEnabled = false;
      };

      zramSwap = {
        enable = true;
        memoryPercent = 50; # ~4 GB compressed
      };

      swapDevices = [
        {
          device = "/swapfile";
          size = 8 * 1024; # 8GB
        }
      ];

      services.openssh.enable = true;

      system.stateVersion = "25.05";
    };

  flake.homeModules.laptop-nixos =
    {
      pkgs,
      pkgsUnstable,
      ...
    }:
    {

      home.packages =
        with pkgs;
        [
          vlc
          localsend
        ]
        ++ (with pkgsUnstable; [
          (discord.override {
            withOpenASAR = true;
            withVencord = true;
            enableAutoscroll = true;
          })
        ]);

      xdg.desktopEntries.reboot-to-windows = {
        name = "Reboot to Windows";
        comment = "Restart the system and boot into Windows";
        icon = ../../../assets/windows-11.png;
        exec = "pkexec systemctl reboot --boot-loader-entry=auto-windows";
        categories = [ "System" ];
        terminal = false;
      };
    };

}
