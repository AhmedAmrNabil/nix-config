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
