{ self, ... }: {
  flake.nixosModules.desktop-nixos = {
    imports = with self.nixosModules; [
      ./_hardware-configuration.nix
      # apps
      distrobox
      gpu-screen-recorder
      microsoft-edge
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
      nix-ld
      nvidia
      users

      # desktop environment
      # hyprland
      kde
    ];
  };

  flake.homeModules.desktop-nixos = {
    imports = with self.homeModules; [
      # alacritty
      bash
      bat
      btop
      cava
      devenv
      direnv
      distrobox
      eza
      fastfetch
      fish
      foot
      git
      # hyprland
      kde
      micro
      microsoft-edge
      nh
      only-office
      # quickshell
      reboot-to-windows
      rofi
      scrcpy
      spotify
      starship
      vscode
      yazi
      zoxide
      zsh
    ];
  };
}
