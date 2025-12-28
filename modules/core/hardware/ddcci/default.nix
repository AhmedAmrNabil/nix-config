{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.core.hardware.ddcci;
in
{
  options.core.hardware.ddcci = {
    enable = lib.mkEnableOption "Enable DDC/CI for montiors";
  };
  config = lib.mkIf cfg.enable {
    hardware.i2c.enable = true;
    services.udev.packages = [ pkgs.ddcutil ];
    boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
    boot.kernelModules = [
      "i2c-dev"
      "ddcci_backlight"
    ];
    services.udev.extraRules = ''
      SUBSYSTEM=="i2c-dev", ACTION=="add", ATTR{name}=="NVIDIA i2c adapter*", TAG+="ddcci", TAG+="systemd", ENV{SYSTEMD_WANTS}+="ddcci@$kernel.service"
    '';

    systemd.services."ddcci@" = {
      scriptArgs = "%i";
      after = [ "graphical.target" ];
      path = [
        pkgs.i2c-tools
      ];
      script = ''
        echo "Trying to attach ddcci to $1"
        id=$(echo $1 | cut -d "-" -f 2)
        echo "id: $id"

        if ! i2cdetect -y $id 0x37 0x37 | grep -q 37; then
          echo "Cannot find 0x37 device"
          exit 0
        fi

        echo "ddcci 0x37" > /sys/bus/i2c/devices/$1/new_device && echo "Successfully attached ddcci to $1" || echo "Failed to attach"
      '';

      serviceConfig = {
        Type = "oneshot";
        Restart = "no";
      };
    };
  };
}
