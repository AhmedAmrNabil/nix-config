{ self, inputs, ... }: {
  flake.nixosModules.daedalus = {
    imports = with self.nixosModules; [
      nh

      # services
      docker
      tailscale

      # system
      kernel
      nix-cfg
      users
      inputs.determinate.nixosModules.default
    ];
  };

  flake.homeModules.daedalus = {
  };
}
