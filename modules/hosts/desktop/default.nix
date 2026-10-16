{ inputs, self, ... }: {
  flake.nixosModules.desktop-nixos =
    {
      pkgs,
      pkgsUnstable,
      ...
    }:
    {
      imports = with self.nixosModules; [
        # apps
        catppuccin
        distrobox
        gpu-screen-recorder
        microsoft-edge
        obs
        open-tablet-driver
        scrcpy
        steam

        # services
        docker
        podman
        tailscale
        # virt-manager
        v4l2loopback

        # system
        audio
        boot
        ddcci
        fonts
        kernel
        nix-cfg
        nix-ld
        nvidia
        users

        # desktop environment
        # hyprland
        kde
      ];
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
      time.hardwareClockInLocalTime = false;

      # --------- Services ------------------
      services.openssh.enable = true;

      # disable some services that are not needed
      systemd.services.NetworkManager-wait-online.enable = false;
      services.fwupd.enable = false;

      # --------- Packages ------------------
      environment.systemPackages =
        with pkgs;
        [
          nano
        ]
        ++ (with pkgsUnstable; [
          cudaPackages.cuda_nvcc
        ]);

      environment.sessionVariables = {
        CUDA_HOME = "${pkgsUnstable.cudaPackages.cuda_nvcc}";
      };

      # -------- Extra Configuration -----------------
      services.hardware.openrgb = {
        enable = true;
        package = pkgs.openrgb-with-all-plugins;
        motherboard = "amd";
      };

      programs.localsend.enable = true;
      documentation.nixos.enable = false;

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
    let
      # Quick nixpkgs search from the CLI (wraps nix-search-tv)
      ns = pkgs.writeShellApplication {
        name = "ns";
        text = builtins.readFile (inputs.nix-search-tv.outPath + "/nixpkgs.sh");
        runtimeInputs = [
          (pkgs.buildGoModule {
            pname = "nix-search-tv";
            version = inputs.nix-search-tv.shortRev or inputs.nix-search-tv.dirtyShortRev or "unknown";
            src = inputs.nix-search-tv.outPath;

            vendorHash = "sha256-SSKDo4A8Nhvylghrw6d7CdHpZ7jObEr5V3r0Y9cH80Y=";

            subPackages = [ "cmd/nix-search-tv" ];

            env.GOEXPERIMENT = "jsonv2";

            meta = {
              description = "A tool integrating television and nix-search packages";
              homepage = "https://github.com/3timeslazy/nix-search-tv";
              mainProgram = "nix-search-tv";
            };
          })
        ];
      };

      # Discord with Vencord and autoscroll
      discord = pkgs.discord.override {
        withVencord = true;
        withOpenASAR = true;
        enableAutoscroll = true;
        # workaround for keybinds not working in wayland
        commandLineArgs = "--ozone-platform=x11";
        vencord = pkgsUnstable.vencord;
      };

      # gdu wrapper that skips mounted fs and /run and /mnt
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
      imports = with self.homeModules; [
        # alacritty
        bash
        bat
        btop
        catppuccin
        cava
        devenv
        direnv
        distrobox
        eza
        fastfetch
        fish
        foot
        git
        # hyprland
        kde
        micro
        microsoft-edge
        nh
        only-office
        # quickshell
        reboot-to-windows
        rofi
        scrcpy
        spotify
        starship
        tmux
        vscode
        yazi
        zoxide
        zsh
        inputs.nix-index-database.homeModules.default
      ];

      home.shellAliases = {
        "..." = "cd ../..";
        clock = "${lib.getExe pkgs.tty-clock} -tcDBC 4";
        build-iso = "nix build ${dotfilesDir}#nixosConfigurations.iso-nixos.config.system.build.isoImage";
      };

      programs.nix-index-database.comma.enable = true;
      programs.nix-your-shell.enable = true;
      programs.fzf = {
        enable = true;
        tmux.enableShellIntegration = true;
        defaultOptions = [
          "--height=40%"
          "--layout=reverse"
          "--border"
        ];
        # Ctrl-T: files and dirs
        fileWidget.options = [
          "--preview 'test -d {}; and eza --tree --level=2 --color=always {}; or bat --color=always --line-range=:200 {}'"
        ];
        # Alt-C: dirs only
        changeDirWidget.options = [
          "--preview 'eza --tree --level=2 --color=always {}'"
        ];
      };

      home.packages =
        with pkgs;
        [
          # cli utils
          gdu
          jq
          killall
          pciutils
          tty-clock
          usbutils
          wayland-utils
          wl-clipboard
          xhost

          # nix utils
          nixd
          nixfmt
          nix-output-monitor
          mcp-nixos

          # development
          jdk25
          nodejs_22
          pnpm
          # python3
          uv
          github-cli
          awscli2
          claude-code
          android-tools

          # gui apps
          element-desktop
          handbrake
          libnotify
          transmission_4-qt
          vlc
          xournalpp
          teams-for-linux

          # gaming
          mangohud
          discover-overlay
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
          cisco-packet-tracer_9
          notion-app
        ])
        ++ [
          ns
          discord
          gdu-clean
        ];
    };
}
