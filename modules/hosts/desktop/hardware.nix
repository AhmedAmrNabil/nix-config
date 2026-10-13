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
  flake.nixosModules.desktop-nixos =
    {
      config,
      lib,
      modulesPath,
      homeDir,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "uas"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/2b9d4cde-3908-427c-936f-ff16eebf8045";
        fsType = "btrfs";
        options = [
          "subvol=@"
          "compress=zstd"
        ];
      };

      fileSystems."/home" = {
        device = "/dev/disk/by-uuid/2b9d4cde-3908-427c-936f-ff16eebf8045";
        fsType = "btrfs";
        options = [
          "subvol=@home"
          "compress=zstd"
        ];
      };

      fileSystems."/nix" = {
        device = "/dev/disk/by-uuid/2b9d4cde-3908-427c-936f-ff16eebf8045";
        fsType = "btrfs";
        options = [
          "subvol=@nix"
          "compress=zstd"
          "noatime"
        ];
      };

      fileSystems."/persist" = {
        device = "/dev/disk/by-uuid/2b9d4cde-3908-427c-936f-ff16eebf8045";
        fsType = "btrfs";
        options = [
          "subvol=@persist"
          "compress=zstd"
        ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/A638-A2B0";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };

      fileSystems."/swap" = {
        device = "/dev/disk/by-uuid/2b9d4cde-3908-427c-936f-ff16eebf8045";
        fsType = "btrfs";
        options = [
          "subvol=@swap"
          "noatime"
        ];
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

      swapDevices = [
        {
          device = "/swap/swapfile";
          size = 16384; # 16GB in MB
        }
      ];

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      networking.useDHCP = lib.mkDefault true;
      # networking.interfaces.enp42s0.useDHCP = lib.mkDefault true;
      # networking.interfaces.wlp41s0.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
