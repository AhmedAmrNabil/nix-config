{ username, ... }:
let
  homeDirectory = "/home/${username}";
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
  # Mounting windows hdd for media and games:
  fileSystems."${homeDirectory}/hdd" = {
    device = "/dev/disk/by-uuid/01DAB93F51B44DA0";
    fsType = "ntfs";
    options = ntfsOptions;
  };

  # Bind mount Videos and Downloads from hdd to home
  fileSystems."${homeDirectory}/Videos" = {
    device = "${homeDirectory}/hdd/Videos";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "${homeDirectory}/hdd" ];
  };

  fileSystems."${homeDirectory}/Downloads" = {
    device = "${homeDirectory}/hdd/Downloads";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "${homeDirectory}/hdd" ];
  };

  fileSystems."${homeDirectory}/crucial" = {
    device = "/dev/disk/by-uuid/01DD0394B2474040";
    fsType = "ntfs";
    options = ntfsOptions ++ [
      "x-systemd.automount"
      "noauto"
    ];
  };

  fileSystems."${homeDirectory}/Games" = {
    device = "${homeDirectory}/crucial/Games";
    fsType = "none";
    options = [
      "bind"
      "nofail"
      "x-systemd.device-timeout=3s"
      "x-systemd.automount"
      "noauto"
    ];
    depends = [ "${homeDirectory}/crucial" ];
  };

  # fix steam compatdata to be on linux instead of ntfs partiton
  systemd.tmpfiles.rules = [
    "L ${homeDirectory}/crucial/SteamLibrary/steamapps/compatdata - - - - ${homeDirectory}/.steam/steam/steamapps/compatdata"
    "L ${homeDirectory}/hdd/SteamLibrary/steamapps/compatdata - - - - ${homeDirectory}/.steam/steam/steamapps/compatdata2"
  ];
}
