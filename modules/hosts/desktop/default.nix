{ self, ... }: {
  flake.nixosModules.desktop-nixos = {
    imports = with self.nixosModules; [
      ./_hardware-configuration.nix
      # apps
      docker
      gpu-screen-recorder
      nh
      obs
      open-tablet-driver
      steam
      tailscale
      virt-manager

      # core
      audio
      boot
      fonts
      ddcci
      nvidia
      kernel
      nix-cfg
      users
      kde
      hyprland
    ];
  };

  flake.homeModules.desktop-nixos = {
    imports = with self.homeModules; [
      alacritty
      cava
      foot
      only-office
      rofi
      spotify
      vscode
      yazi
      quickshell
      devenv
      hyprland
    ];
  };
}
