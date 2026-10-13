{ self, ... }: {
  flake.nixosModules.laptop-nixos = {
    imports = with self.nixosModules; [
      ./_hardware-configuration.nix
      tailscale
      microsoft-edge
      audio
      boot
      fonts
      kernel
      nix-cfg
      users
      kde
    ];
  };

  flake.homeModules.laptop-nixos = {
    imports = with self.homeModules; [
      foot
      microsoft-edge
      nh
      reboot-to-windows
      vscode
      spotify
      rofi

      bash
      bat
      btop
      direnv
      eza
      fastfetch
      fish
      git
      micro
      starship
      zoxide
      devenv
      yazi
    ];
  };
}
