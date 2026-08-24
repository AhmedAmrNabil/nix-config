{
  flake.nixosModules.boot = {
    boot.loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    boot.initrd.verbose = false;
    boot.consoleLogLevel = 3;
    boot.kernelParams = [
      "udev.log_priority=3"
      "boot.shell_on_fail"
      "rd.systemd.show_status=auto"
    ];
  };
}
