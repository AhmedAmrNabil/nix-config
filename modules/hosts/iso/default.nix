{ self, ... }: {
  flake.nixosModules.iso-nixos = {
    imports = with self.nixosModules; [
      kde
      fonts
      users
      nvidia
    ];
  };

  flake.homeModules.iso-nixos = {
    imports = with self.homeModules; [
      bash
      bat
      eza
      fastfetch
      fish
      micro
      starship
      zoxide
      foot
    ];
  };
}
