{
  flake.nixosModules.desktop-nixos =
    {
      pkgs,
      ...
    }:
    {
      # --------- Hostname and networking ------------------
      # Hostname is defined in mkSystem, so it can be set per-host.
      networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
      networking.modemmanager.enable = false; # disable unused, speeds up boot
      networking.firewall.checkReversePath = false;

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

      # disable some services that are not needed
      systemd.services.Networkmanager-wait-online.enable = false;
      services.fwupd.enable = false;

      # --------- Packages ------------------
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
        deskflow
      ];

      # this is out of place but it is the only way to disable the annoying security warning when launching edge with custom flags
      environment.etc."opt/edge/policies/managed/policies.json".text = builtins.toJSON {
        CommandLineFlagSecurityWarningsEnabled = false;
      };

      # --------- Extra boot params ------------------
      boot.kernelParams = [
        "mem_sleep_default=deep"
      ];
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", KERNEL=="usb1", ATTR{power/wakeup}="enabled"
        ACTION=="add", SUBSYSTEM=="usb", KERNEL=="usb3", ATTR{power/wakeup}="enabled"
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1ea7", ATTR{idProduct}=="0907", ATTR{power/wakeup}="enabled"
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="0085", ATTR{power/wakeup}="enabled"
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="028e", ATTR{power/wakeup}="enabled"
      '';

      # -------- Extra Configuration -----------------
      services.hardware.openrgb = {
        enable = true;
        package = pkgs.openrgb-with-all-plugins;
        motherboard = "amd";
      };

      # --------- Swap ------------------
      swapDevices = [
        {
          device = "/swap/swapfile";
          size = 16384; # 16GB in MB
        }
      ];

      system.stateVersion = "25.05";
    };

  flake.homeModules.desktop-nixos =
    {
      pkgs,
      self',
      pkgsUnstable,
      lib,
      dotfilesDir,
      ...
    }:
    {
      programs.nix-index.enable = true; # enable nix-index for faster package searching

      home.shellAliases = {
        "..." = "cd ../..";
        clock = "${lib.getExe pkgs.tty-clock} -tcDBC 4";
        build-iso = "nix build ${dotfilesDir}#nixosConfigurations.iso-nixos.config.system.build.isoImage";
      };

      home.packages =
        with pkgs;
        [
          element-desktop
          handbrake
          jdk25
          libnotify
          localsend
          microsoft-edge
          transmission_4-qt
          tty-clock
          vlc
          xournalpp
          teams-for-linux
          uv
          github-cli
          mangohud
          android-tools
          (pkgs.writeShellScriptBin "gdu-clean" ''
            #bash
            IGNORE=$(
              findmnt --raw --noheadings --output TARGET,FSTYPE \
                | awk '$2 == "fuseblk" {print $1}' \
                | paste -sd "," -
            )

            IGNORE="$IGNORE,/run,/mnt"
            exec ${pkgs.gdu}/bin/gdu --ignore-dirs "$IGNORE" $@
          '')
          (discord.override {
            withVencord = true;
            enableAutoscroll = true;
            # workaround for keybinds not working in wayland
            commandLineArgs = "--ozone-platform=x11";
            vencord = pkgsUnstable.vencord;
          })
          discover-overlay
          claude-code
          awscli2
        ]
        ++ (with pkgsUnstable; [
          google-antigravity-no-fhs
          google-antigravity-cli
          helium
          open-scq30
          postman
          inkscape
        ])
        ++ (with self'.packages; [
          obsidian
          claude-desktop
          prismlauncher-9
        ]);

      programs.nix-your-shell = {
        enable = true;
        nix-output-monitor.enable = true;
      };

      xdg.desktopEntries.reboot-to-windows = {
        name = "Reboot to Windows";
        comment = "Restart the system and boot into Windows";
        icon = ../../../assets/windows-11.png;
        exec = "pkexec systemctl reboot --boot-loader-entry=auto-windows";
        categories = [ "System" ];
        terminal = false;
      };

      systemd.user.services.test-service = {
        Unit = {
          Description = "Test Service";
          After = [ "network.target" ];
        };
        Service = {
          Type = "simple";
          Environment = "PATH=${pkgs.ffmpeg-full}/bin";
          WorkingDirectory = "/home/btngana/coding/test-service";
          ExecStart = "/home/btngana/coding/test-service/.devenv/state/venv/bin/python /home/btngana/coding/test-service/service.py";
          Restart = "on-failure";
          RestartSec = 5;
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
}
