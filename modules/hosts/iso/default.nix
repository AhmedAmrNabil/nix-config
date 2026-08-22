{ self, ... }: {
  flake.nixosModules.iso = {
    imports = with self.nixosModules; [
      kde
      fonts
      users
      nvidia
    ];
  };

  flake.homeModules.iso = {
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
