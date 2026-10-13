{
  flake.homeModules.reboot-to-windows = {
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
