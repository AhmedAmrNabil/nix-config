{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      localPkgs = import ./pkgs {
        inherit pkgs;
      };
    in
    {
      nixosConfigurations = {
        desktop-nixos = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./configuration.nix
          ];
        };
      };
      homeConfigurations = {
        btngana = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit inputs localPkgs; };
        };
      };
    };
}
