{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.open-tablet-driver;
in
{
  options.apps.open-tablet-driver = {
    enable = lib.mkEnableOption "OpenTabletDriver for drawing tablets";
  };
  config = lib.mkIf cfg.enable {

    # Enable OpenTabletDriver for drawing tablets
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };

    # Required by OpenTabletDriver
    hardware.uinput.enable = true;
    boot.kernelModules = [ "uinput" ];
    boot.blacklistedKernelModules = [ "wacom" ];

    home-manager.users.${username}.imports = [
      ./home.nix
    ];
  };
}
