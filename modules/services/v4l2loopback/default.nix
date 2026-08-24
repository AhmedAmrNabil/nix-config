{
  flake.nixosModules.v4l2loopback =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.v4l2loopback;
      devicesCount = lib.length cfg.devices;
      videoNumbers = lib.concatStringsSep "," (map (device: toString device.index) cfg.devices);
      cardLabels = lib.concatStringsSep "," (map (device: device.name) cfg.devices);
      exclusiveCaps = lib.concatStringsSep "," (map (device: toString device.exclusiveCaps) cfg.devices);

      indexes = map (device: device.index) cfg.devices;
      uniqueIndexes = lib.unique indexes;
      duplicates = lib.filter (i: lib.count (x: x == i) indexes > 1) uniqueIndexes;
      devicesWithDup = lib.filter (d: lib.elem d.index duplicates) cfg.devices;
    in
    {
      options.v4l2loopback = {
        devices = lib.mkOption {
          type = lib.types.listOf (
            lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  default = "Virtual Camera";
                  description = ''
                    The name of the virtual camera created by v4l2loopback.
                  '';
                };
                index = lib.mkOption {
                  type = lib.types.int;
                  default = 0;
                  description = ''
                    The index of the virtual camera created by v4l2loopback.
                  '';
                };

                exclusiveCaps = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = ''
                    Whether the virtual camera should have exclusive capabilities.
                  '';
                };
              };
            }
          );
          default = [ ];
          description = ''
            Names of the virtual cameras created by v4l2loopback.
          '';
        };
      };

      config = lib.mkIf (devicesCount > 0) {
        assertions = [
          {
            assertion = duplicates == [ ];
            message = ''
              v4l2loopback.devices: indexes must be unique.
              Duplicate index(es): ${lib.concatStringsSep ", " (map toString duplicates)}
              Conflicting devices: ${
                lib.concatMapStringsSep ", " (d: ''"${d.name}" (index ${toString d.index})'') devicesWithDup
              }
            '';
          }
        ];
        boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
        boot.kernelModules = [ "v4l2loopback" ];
        boot.extraModprobeConfig = ''
          options v4l2loopback \
            devices=${toString devicesCount} \
            video_nr=${videoNumbers} \
            card_label="${cardLabels}" \
            exclusive_caps=${exclusiveCaps}
        '';
      };
    };
}
