{ self, inputs, ... }: {
  flake.nixosModules.iso-nixos =
    {
      pkgs,
      modulesPath,
      lib,
      username,
      pkgsUnstable,
      pkgsLocal,
      homeDir,
      dotfilesDir,
      ...
    }:
    {
      imports = with self.nixosModules; [
        # Include the results of the hardware scan.
        "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        inputs.home-manager.nixosModules.home-manager

        kde
        fonts
        users
        nvidia
      ];

      nixpkgs.hostPlatform = "x86_64-linux";
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
      boot.loader.timeout = lib.mkForce 10;
      boot.zfs.forceImportRoot = false;
      boot.supportedFilesystems = {
        zfs = lib.mkForce false;
      };

      environment.systemPackages = with pkgs; [
        micro
        git
        firefox
        killall
        usbutils
        wayland-utils
        wl-clipboard
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit username homeDir dotfilesDir;
          inherit pkgsUnstable pkgsLocal;
        };
        users.${username} = {
          home.file."mountfs.sh" = {
            source = ../../../modules/scripts/mountfs.sh;
            executable = true;
          };
          imports = [
            self.homeModules.iso-nixos
          ];
          home.packages = with pkgs; [
            gdu
            jq
            killall
            nixd
            nixfmt
          ];
          home.stateVersion = "25.11";
        };
      };

      virtualisation.vmVariant = {
        virtualisation.memorySize = 8192; # 8GB
        virtualisation.cores = 4;
        virtualisation.qemu.options = [
          "-vga none"
          "-device virtio-vga-gl"
          "-display gtk,gl=on"
        ];
      };

      services.speechd.enable = lib.mkForce false;
      system.stateVersion = "25.05";
    };

  flake.homeModules.iso-nixos = {
    imports = with self.homeModules; [
      shell
      btop
      git
      micro
    ];
  };
}
