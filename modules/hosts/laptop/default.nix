{ self, ... }: {
  flake.nixosModules.laptop-nixos =
    {
      pkgs,
      ...
    }:
    {
      imports = with self.nixosModules; [
        tailscale
        microsoft-edge
        audio
        boot
        fonts
        kernel
        nix-cfg
        users
        kde
      ];

      # Enable networking
      networking.networkmanager.enable = true;
      networking.firewall.allowedTCPPorts = [
        5000
        5005
      ];

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
      imports = with self.homeModules; [
        shell
        foot
        microsoft-edge
        nh
        reboot-to-windows
        vscode
        spotify
        rofi
        btop
        git
        micro
      ];

      home.packages =
        with pkgs;
        [
          vlc
          localsend
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
