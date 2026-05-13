{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-local = {
      url = "path:/home/btngana/coding/nixpkgs";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-local,
      nixos-wsl,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      overlays = [
        (import ./overlays/xournalpp)
        (final: prev: import ./packages { pkgs = final; })
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      pkgsUnstable = import nixpkgs-unstable {
        inherit system overlays;
        config.allowUnfree = true;
      };

      pkgsLocal = import nixpkgs-local {
        inherit system overlays;
        config.allowUnfree = true;
      };

      username = "btngana";

      gitConfig = {
        userName = "AhmedAmrNabil";
        userEmail = "ahmedamr24680@gmail.com";
      };

      commonModules = [
        ./modules
        inputs.hyprland.nixosModules.default
        { nixpkgs.pkgs = pkgs; }
      ];

      specialArgs = {
        inherit
          gitConfig
          inputs
          pkgsLocal
          pkgsUnstable
          system
          username
          ;
      };

      mkSystem =
        host: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./hosts/${host}/configuration.nix ] ++ commonModules ++ extraModules;
        };

      mkHome =
        profile:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules = [
            ./home/profiles/${profile}.nix
            inputs.spicetify-nix.homeManagerModules.default
          ];
        };
    in
    {
      nixosConfigurations = {
        desktop-nixos = mkSystem "desktop" [ ];
        laptop-nixos = mkSystem "laptop" [ ];
        wsl-nixos = mkSystem "wsl" [ nixos-wsl.nixosModules.default ];
      };

      homeConfigurations = {
        "${username}@desktop-nixos" = mkHome "desktop";
        "${username}@laptop-nixos" = mkHome "laptop";
        "${username}@wsl-nixos" = mkHome "wsl";
      };

      # export nixpkgs to use with nix shell
      legacyPackages.${system} = pkgs // {
        unstable = pkgsUnstable;
        local = pkgsLocal;
      };

      packages.${system} = pkgs;
    };
}
