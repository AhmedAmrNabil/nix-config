{
  pkgs,
  pkgsUnstable,
  lib,
  ...
}:
let

  windowsIconPkg = pkgs.runCommand "windows-logo-icon" { } ''
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp ${./windows-11.png} $out/share/icons/hicolor/256x256/apps/windows-logo.png
  '';

in
{
  imports = [
    ./shared.nix
  ];

  apps = {
    alacritty.enable = true;
    cava.enable = true;
    foot.enable = true;
    only-office.enable = true;
    open-tablet-driver.enable = true;
    rofi.enable = true;
    spotify.enable = true;
    vscode.enable = true;
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
      usbutils
      obsidian
      handbrake
      windowsIconPkg
      libreoffice
      (blender.override { cudaSupport = true; })
    ]
    ++ (with pkgsUnstable; [
      arduino-ide
      arduino-cli
      platformio
      antigravity
      (discord.override {
        withVencord = true;
        enableAutoscroll = true;
      })
    ]);

  xdg.desktopEntries.microsoft-edge-autoscroll = {
    name = "Microsoft Edge (Autoscroll)";
    genericName = "Web Browser";
    exec = "microsoft-edge --enable-blink-features=MiddleClickAutoscroll %U";
    icon = "microsoft-edge";
    categories = [
      "Network"
      "WebBrowser"
    ];
  };

  xdg.desktopEntries.reboot-to-windows = {
    name = "Reboot to Windows";
    comment = "Restart the system and boot into Windows";
    icon = "windows-logo";
    exec = "pkexec systemctl reboot --boot-loader-entry=auto-windows";
    categories = [ "System" ];
    terminal = false;
  };
}
