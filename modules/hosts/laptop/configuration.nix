{
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
        kdePackages.print-manager
      ];

      hardware.bluetooth.enable = true;

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
    let
      # Discord with Vencord and autoscroll
      discord = pkgs.discord.override {
        withVencord = true;
        withOpenASAR = true;
        enableAutoscroll = true;
        # workaround for keybinds not working in wayland
        commandLineArgs = "--ozone-platform=x11";
        vencord = pkgsUnstable.vencord;
      };
    in
    {

      home.packages =
        with pkgs;
        [
          vlc
          localsend
          fzf
          gdu
          jq
          killall
          nixd
          nixfmt
        ]
        ++ [
          discord
        ];
    };

}
