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
      xournalpp
      vlc
      localsend
      transmission_4-qt
      teams-for-linux
      postman
      avalonia-ilspy
      obsidian
      handbrake
      # libreoffice
      element-desktop
      # (blender.override { cudaSupport = true; })
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
      tty-clock
      microsoft-edge
      prismlauncher-9
      jdk25
      kdePackages.kdialog
      hydra-check
      killall
      libnotify
    ]
    ++ (with pkgsUnstable; [
      (discord.override {
        withVencord = true;
        enableAutoscroll = true;
        commandLineArgs = "--ozone-platform=x11";
      })
    ]);

  xdg.desktopEntries.reboot-to-windows = {
    name = "Reboot to Windows";
    comment = "Restart the system and boot into Windows";
    icon = "${../../assets/windows-11.png}";
    exec = "pkexec systemctl reboot --boot-loader-entry=auto-windows";
    categories = [ "System" ];
    terminal = false;
  };
}
