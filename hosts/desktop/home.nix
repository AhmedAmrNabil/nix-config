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
      postman
      prismlauncher-9
      transmission_4-qt
      tty-clock
      vlc
      xournalpp
      claude-desktop
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
    ]
    ++ (with pkgsUnstable; [
      (discord.override {
        withVencord = true;
        enableAutoscroll = true;
        # workaround for keybinds not working in wayland
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
