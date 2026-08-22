{ self, ... }: {
  flake.nixosModules.laptop-nixos = {
    imports = with self.nixosModules; [
      ./_hardware-configuration.nix
      nh
      tailscale
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
      vscode
      spotify
      rofi
    ];
  };
}
