{ self, ... }: {
  flake.nixosModules.laptop-nixos = {
    imports = with self.nixosModules; [
      ./_hardware-configuration.nix
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
      nh
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
