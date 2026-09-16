{
  flake.nixosModules.v4l2loopback =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.hardware.v4l2loopback;
      enabledDevices = lib.attrValues (lib.filterAttrs (_: d: d.enable) cfg.devices);

      explicitDevices = lib.filter (d: d.index != null) enabledDevices;
      autoDevices = lib.filter (d: d.index == null) enabledDevices;
      usedIndices = map (d: d.index) explicitDevices;

      searchBound = lib.length enabledDevices + (lib.foldl' lib.max 0 usedIndices);
      availableIndices = lib.filter (i: !(lib.elem i usedIndices)) (lib.range 0 searchBound);

      autoAssignedDevices = lib.zipListsWith (d: i: d // { index = i; }) autoDevices (
        lib.take (lib.length autoDevices) availableIndices
      );

      finalDevices = explicitDevices ++ autoAssignedDevices;
      devicesCount = lib.length finalDevices;
      videoNumbers = lib.concatStringsSep "," (map (device: toString device.index) finalDevices);
      cardLabels = lib.concatStringsSep "," (map (device: device.name) finalDevices);
      exclusiveCaps = lib.concatStringsSep "," (
        map (device: if device.exclusiveCaps then "1" else "0") finalDevices
      );

      indicies = map (device: device.index) finalDevices;
      uniqueIndices = lib.unique indicies;
      duplicates = lib.filter (i: lib.count (x: x == i) indicies > 1) uniqueIndices;
      devicesWithDup = lib.filter (d: lib.elem d.index duplicates) finalDevices;
    in
    {
      options.hardware.v4l2loopback = {
        enable = lib.mkEnableOption "v4l2loopback virtual cameras";

        devices = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule (
              { name, ... }:
              {
                options = {
                  enable = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                    description = "Whether this virtual camera device is enabled.";
                  };

                  name = lib.mkOption {
                    type = lib.types.str;
                    default = name;
                    description = "The name of the virtual camera created by v4l2loopback.";
                  };

                  index = lib.mkOption {
                    type = lib.types.nullOr lib.types.int;
                    default = null;
                    description = "The index of the virtual camera created by v4l2loopback. leave as null to automatically assign the next available index.";
                  };

                  exclusiveCaps = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                    description = "Whether the virtual camera should have exclusive capabilities.";
                  };
                };
              }
            )
          );
          default = { };
          description = "Virtual cameras to create with v4l2loopback, keyed by an attribute name.";
        };
      };

      config = lib.mkIf (cfg.enable && devicesCount > 0) {
        assertions = [
          {
            assertion = duplicates == [ ];
            message = ''
              hardware.v4l2loopback.devices: indexes must be unique.
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
