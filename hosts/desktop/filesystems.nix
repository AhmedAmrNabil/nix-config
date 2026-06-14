{ username, ... }:
let
  homeDirectory = "/home/${username}";
  ntfsOptions = [
    "windows_names"
    "uid=1000"
    "gid=100"
    "umask=022"
    "big_writes"
    "nofail"
    "exec"
    "rw"
    "x-systemd.device-timeout=3s"
    "x-systemd.automount"
    "noauto"
    "x-systemd.idle-timeout=60" # optional: auto-unmount when idle
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
    device = "/dev/disk/by-uuid/7A5AE84D5AE807A9";
    fsType = "ntfs";
    options = ntfsOptions;
  };

  fileSystems."${homeDirectory}/Games" = {
    device = "${homeDirectory}/crucial/Games";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "${homeDirectory}/crucial" ];
  };

  # fix steam compatdata to be on linux instead of ntfs partiton
  systemd.tmpfiles.rules = [
    "L ${homeDirectory}/crucial/SteamLibrary/steamapps/compatdata - - - - ${homeDirectory}/.steam/steam/steamapps/compatdata"
    "L ${homeDirectory}/hdd/SteamLibrary/steamapps/compatdata - - - - ${homeDirectory}/.steam/steam/steamapps/compatdata2"
  ];

  # Mounting windows partition for save files
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/3C0A93A20A93582A";
    fsType = "ntfs";
    options = ntfsOptions;
  };

  fileSystems."${homeDirectory}/wineprefixes/claire/drive_c/users/Public/Documents" = {
    device = "/mnt/windows/Users/Public/Documents";
    fsType = "none";
    options = [
      "bind"
      "nofail" # don't block boot if /mnt/windows isn't up
      "x-systemd.requires-mounts-for=/mnt/windows" # proper ordering without hard dep
    ];
    depends = [ "/mnt/windows" ];
  };
}
