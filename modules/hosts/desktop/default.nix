{ self,inputs, ... }: {
  flake.nixosModules.desktop-nixos = {
    imports = with self.nixosModules; [
      ./_hardware-configuration.nix
      # apps
      gpu-screen-recorder
      nh
      obs
      open-tablet-driver
      scrcpy
      steam

      # services
      docker
      podman
      tailscale
      # virt-manager
      v4l2loopback

      # system
      audio
      boot
      ddcci
      fonts
      kernel
      nix-cfg
      nvidia
      users

      # desktop environment
      # hyprland
      kde

      inputs.determinate.nixosModules.default
    ];
  };

  flake.homeModules.desktop-nixos = {
    imports = with self.homeModules; [
      kde
      # alacritty
      cava
      devenv
      foot
      # hyprland
      only-office
      # quickshell
      rofi
      scrcpy
      spotify
      vscode
      yazi
    ];
  };
}
