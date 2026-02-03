{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
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
      nixos-wsl,
      home-manager,
      nix-vscode-extensions,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      overlays = [
        (import ./overlays/xournalpp)
        nix-vscode-extensions.overlays.default
      ];

      # Evaluate pkgs once and reuse
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
      pkgsUnstable = import inputs.nixpkgs-unstable {
        inherit system overlays;
        config.allowUnfree = true;
      };

      localPkgs = import ./packages { inherit pkgs; };

      username = "btngana";

      gitConfig = {
        userName = "AhmedAmrNabil";
        userEmail = "ahmedamr24680@gmail.com";
      };

      commonModules = [
        ./modules
        inputs.hyprland.nixosModules.default
        { nixpkgs.overlays = overlays; }
      ];

      specialArgs = {
        inherit
          inputs
          system
          localPkgs
          username
          pkgsUnstable
          ;
      };

      mkSystem =
        host: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./hosts/${host}/configuration.nix ] ++ commonModules ++ extraModules;
        };

      # Home Manager standalone configuration
      homeExtraSpecialArgs = {
        inherit
          inputs
          localPkgs
          system
          pkgsUnstable
          gitConfig
          username
          ;
      };

      mkHome =
        profile:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = homeExtraSpecialArgs;
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
      legacyPackages.${system} = pkgs;
    };
}
