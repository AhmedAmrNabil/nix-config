{ inputs, ... }: {
  flake.nixosModules.desktop-nixos =
    {
      pkgs,
      ...
    }:
    {
      # --------- Networking ------------------
      # Hostname is defined in mkSystem, so it can be set per-host.
      networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
      networking.modemmanager.enable = false; # disable unused, speeds up boot

      # Netlify servers ip's are blocked from the ISP for some reason
      # this is a workaround to make them accessible
      networking.extraHosts = ''
        75.2.60.5 kops.sigs.k8s.io
        75.2.60.5 docs.kargo.io
        75.2.60.5 flakehub.com
        75.2.60.5 search.nixos.org
        75.2.60.5 flake.parts
        75.2.60.5 nix.dev
        75.2.60.5 status.nixos.org
      '';

      services.cloudflare-warp.enable = true;

      hardware.bluetooth.enable = true;

      # --------- Timezone and clock ------------------
      time.timeZone = "Africa/Cairo";
      time.hardwareClockInLocalTime = true;

      # --------- Services ------------------
      services.openssh.enable = true;

      # disable some services that are not needed
      systemd.services.NetworkManager-wait-online.enable = false;
      services.fwupd.enable = false;

      # --------- Packages ------------------
      environment.systemPackages = with pkgs; [
        nano
      ];

      programs.localsend.enable = true;

      # this is out of place but it is the only way to disable the annoying security warning when launching edge with custom flags
      environment.etc."opt/edge/policies/managed/policies.json".text = builtins.toJSON {
        CommandLineFlagSecurityWarningsEnabled = false;
      };

      # -------- Extra Configuration -----------------
      services.hardware.openrgb = {
        enable = true;
        package = pkgs.openrgb-with-all-plugins;
        motherboard = "amd";
      };

      documentation.nixos.enable = false;

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
      inputs',
      ...
    }:
    let
      ns = pkgs.writeShellApplication {
        name = "ns";
        text = builtins.readFile (inputs.nix-search-tv.outPath + "/nixpkgs.sh");
        runtimeInputs = [ inputs'.nix-search-tv.packages.default ];
      };

      discord = pkgs.discord.override {
        withVencord = true;
        enableAutoscroll = true;
        # workaround for keybinds not working in wayland
        commandLineArgs = "--ozone-platform=x11";
        vencord = pkgsUnstable.vencord;
      };

      gdu-clean = pkgs.writeShellScriptBin "gdu-clean" ''
        #bash
        IGNORE=$(
          findmnt --raw --noheadings --output TARGET,FSTYPE \
            | awk '$2 == "fuseblk" {print $1}' \
            | paste -sd "," -
        )

        IGNORE="$IGNORE,/run,/mnt"
        exec ${lib.getExe pkgs.gdu} --ignore-dirs "$IGNORE" "$@"
      '';
    in
    {
      home.shellAliases = {
        "..." = "cd ../..";
        clock = "${lib.getExe pkgs.tty-clock} -tcDBC 4";
        build-iso = "nix build ${dotfilesDir}#nixosConfigurations.iso-nixos.config.system.build.isoImage";
      };

      imports = [
        inputs.nix-index-database.homeModules.default
      ];

      programs.nix-index-database.comma.enable = true;

      home.packages =
        with pkgs;
        [
          element-desktop
          handbrake
          jdk25
          libnotify
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
          discover-overlay
          claude-code
          awscli2
          nix-output-monitor
          nodejs_22
          pnpm
          python3
          usbutils
          pciutils
          wayland-utils
          wl-clipboard
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
          notion-app
        ])
        ++ [
          ns
          discord
          gdu-clean
        ];

      programs.nix-your-shell = {
        enable = true;
      };

      xdg.desktopEntries.reboot-to-windows = {
        name = "Reboot to Windows";
        comment = "Restart the system and boot into Windows";
        icon = ../../../assets/windows-11.png;
        exec = "pkexec systemctl reboot --boot-loader-entry=auto-windows";
        categories = [ "System" ];
        terminal = false;
      };

      home.shellAliases = {
        restart-windows = "sudo systemctl reboot --boot-loader-entry=auto-windows";
      };
    };
}
