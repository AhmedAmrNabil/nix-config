{
  flake.nixosModules.laptop-nixos =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      # entries limit override
      boot.loader.systemd-boot.configurationLimit = lib.mkForce 1;

      boot.initrd.availableKernelModules = [
        "vmd"
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/3491bcdb-4252-464d-91ba-7219cc94d75c";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/8AF1-2E71";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      zramSwap = {
        enable = true;
        memoryPercent = 50; # ~4 GB compressed
      };

      swapDevices = [
        {
          device = "/swapfile";
          size = 8 * 1024; # 8GB
        }
      ];

      networking.useDHCP = lib.mkDefault true;
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
