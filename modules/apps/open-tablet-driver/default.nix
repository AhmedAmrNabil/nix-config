{
  ...
}:
{
  # Enable OpenTabletDriver for drawing tablets
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  # Required by OpenTabletDriver
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
  boot.blacklistedKernelModules = [ "wacom" ];
}
