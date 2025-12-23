{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
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

      mkSystem =
        host:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${host}/configuration.nix
          ];
          specialArgs = { inherit inputs system localPkgs; };
        };

      mkHome =
        host:
        let
          systemCfg = mkSystem host;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit (systemCfg) pkgs;
          extraSpecialArgs = { inherit inputs system localPkgs; };
          modules = [
            ./home/profiles/${host}.nix
          ];
        };
    in
    {
      nixosConfigurations = {
        desktop-nixos = mkSystem "desktop";
        laptop-nixos = mkSystem "laptop";
      };
      homeConfigurations = {
        desktop-nixos = mkHome "desktop";
        laptop-nixos = mkHome "laptop";
        wsl-nixos = mkHome "wsl";
      };
    };
}
