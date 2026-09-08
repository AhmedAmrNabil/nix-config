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
    ];
  };
}
