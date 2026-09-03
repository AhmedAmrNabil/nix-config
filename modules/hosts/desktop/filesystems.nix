let
  ntfsOptions = [
    "windows_names"
    "uid=1000"
    "gid=100"
    "umask=022"
    "exec"
    "rw"
    "nofail"
    "x-systemd.device-timeout=30s"
  ];
in
{
  flake.nixosModules.desktop-nixos = { homeDir, ... }: {
    # add zstd compression to file systems
    fileSystems = {
      "/".options = [ "compress=zstd" ];
      "/home".options = [ "compress=zstd" ];
      "/nix".options = [
        "compress=zstd"
        "noatime"
      ];
      "/persist".options = [ "compress=zstd" ];
      "/swap".options = [ "noatime" ];
    };

    # Mounting windows hdd for media and games:
    fileSystems."${homeDir}/hdd" = {
      device = "/dev/disk/by-uuid/01DAB93F51B44DA0";
      fsType = "ntfs";
      options = ntfsOptions;
    };

    # Bind mount Videos and Downloads from hdd to home
    fileSystems."${homeDir}/Videos" = {
      device = "${homeDir}/hdd/Videos";
      fsType = "none";
      options = [
        "bind"
        "nofail"
      ];
      depends = [ "${homeDir}/hdd" ];
    };

    fileSystems."${homeDir}/Downloads" = {
      device = "${homeDir}/hdd/Downloads";
      fsType = "none";
      options = [
        "bind"
        "nofail"
      ];
      depends = [ "${homeDir}/hdd" ];
    };

    fileSystems."${homeDir}/crucial" = {
      device = "/dev/disk/by-uuid/01DD0394B2474040";
      fsType = "ntfs";
      options = ntfsOptions ++ [
        "x-systemd.automount"
        "noauto"
      ];
    };

    fileSystems."${homeDir}/Games" = {
      device = "${homeDir}/crucial/Games";
      fsType = "none";
      options = [
        "bind"
        "nofail"
        "x-systemd.device-timeout=3s"
        "x-systemd.automount"
        "noauto"
      ];
      depends = [ "${homeDir}/crucial" ];
    };

    # fix steam compatdata to be on linux instead of ntfs partiton
    systemd.tmpfiles.rules = [
      "L ${homeDir}/crucial/SteamLibrary/steamapps/compatdata - - - - ${homeDir}/.steam/steam/steamapps/compatdata"
      "L ${homeDir}/hdd/SteamLibrary/steamapps/compatdata - - - - ${homeDir}/.steam/steam/steamapps/compatdata2"
    ];

    specialisation.no-hdd.configuration = {
      fileSystems."${homeDir}/hdd".enable = false;
      fileSystems."${homeDir}/Videos".enable = false;
      fileSystems."${homeDir}/Downloads".enable = false;
    };
  };
}
