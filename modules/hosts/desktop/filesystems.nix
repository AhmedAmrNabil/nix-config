{ homePath, ... }:
let
  ntfsOptions = [
    "windows_names"
    "uid=1000"
    "gid=100"
    "umask=022"
    "big_writes"
    "exec"
    "rw"
    "nofail"
    "x-systemd.device-timeout=3s"
  ];
in
{
  flake.nixosModules.desktop-nixos = {
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
    fileSystems."${homePath}/hdd" = {
      device = "/dev/disk/by-uuid/01DAB93F51B44DA0";
      fsType = "ntfs";
      options = ntfsOptions;
    };

    # Bind mount Videos and Downloads from hdd to home
    fileSystems."${homePath}/Videos" = {
      device = "${homePath}/hdd/Videos";
      fsType = "none";
      options = [ "bind" ];
      depends = [ "${homePath}/hdd" ];
    };

    fileSystems."${homePath}/Downloads" = {
      device = "${homePath}/hdd/Downloads";
      fsType = "none";
      options = [ "bind" ];
      depends = [ "${homePath}/hdd" ];
    };

    fileSystems."${homePath}/crucial" = {
      device = "/dev/disk/by-uuid/01DD0394B2474040";
      fsType = "ntfs";
      options = ntfsOptions ++ [
        "x-systemd.automount"
        "noauto"
      ];
    };

    fileSystems."${homePath}/Games" = {
      device = "${homePath}/crucial/Games";
      fsType = "none";
      options = [
        "bind"
        "nofail"
        "x-systemd.device-timeout=3s"
        "x-systemd.automount"
        "noauto"
      ];
      depends = [ "${homePath}/crucial" ];
    };

    # fix steam compatdata to be on linux instead of ntfs partiton
    systemd.tmpfiles.rules = [
      "L ${homePath}/crucial/SteamLibrary/steamapps/compatdata - - - - ${homePath}/.steam/steam/steamapps/compatdata"
      "L ${homePath}/hdd/SteamLibrary/steamapps/compatdata - - - - ${homePath}/.steam/steam/steamapps/compatdata2"
    ];
  };
}
