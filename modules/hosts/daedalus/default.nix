{ self, inputs, ... }: {
  flake.nixosModules.daedalus = {
    imports = with self.nixosModules; [

      # services
      docker
      tailscale

      # system
      kernel
      nix-cfg
      users
    ];
  };

  flake.homeModules.daedalus = {
    imports = [
      inputs.vscode-server.homeModules.default
      self.homeModules.nh
      self.homeModules.bash
      self.homeModules.bat
      self.homeModules.btop
      self.homeModules.direnv
      self.homeModules.eza
      self.homeModules.fastfetch
      self.homeModules.fish
      self.homeModules.git
      self.homeModules.micro
      self.homeModules.starship
      self.homeModules.zoxide
      self.homeModules.devenv
      self.homeModules.yazi
    ];
  };
}
