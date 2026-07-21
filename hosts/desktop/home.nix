{
  pkgs,
  pkgsUnstable,
  ...
}:
{
  apps = {
    alacritty.enable = true;
    cava.enable = true;
    foot.enable = true;
    only-office.enable = true;
    rofi.enable = true;
    spotify.enable = true;
    vscode.enable = true;
    yazi.enable = true;
    quickshell.enable = true;
  };

  apps.devenv = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  de.hyprland.enable = true;

  programs.nix-index.enable = true; # enable nix-index for faster package searching

  home.shellAliases = {
    "..." = "cd ../..";
    clock = "tty-clock -tcDBC 4";
  };

  home.packages =
    with pkgs;
    [
      element-desktop
      handbrake
      jdk25
      kdePackages.kdialog
      libnotify
      localsend
      microsoft-edge
      obsidian
      prismlauncher-9
      transmission_4-qt
      tty-clock
      vlc
      xournalpp
      claude-desktop
      teams-for-linux
      uv
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
    ]
    ++ (with pkgsUnstable; [
      google-antigravity-no-fhs
      google-antigravity-ide-no-fhs
      google-antigravity-cli
      helium
      postman
      jetbrains.idea
    ]);

  xdg.desktopEntries.reboot-to-windows = {
    name = "Reboot to Windows";
    comment = "Restart the system and boot into Windows";
    icon = "${../../assets/windows-11.png}";
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
      WorkingDirectory = "/home/btngana/coding/test-service";
      ExecStart = "/home/btngana/coding/test-service/.devenv/state/venv/bin/python /home/btngana/coding/test-service/service.py";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
