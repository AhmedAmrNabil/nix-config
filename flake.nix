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
    hyprland.url = "github:hyprwm/Hyprland";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
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
        inherit system;
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
        { nixpkgs.overlays = overlays; }
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs localPkgs system pkgsUnstable gitConfig;
            };
            sharedModules = [ inputs.spicetify-nix.homeManagerModules.default ];
            backupFileExtension = "hm-bak";
            users.${username}.home.stateVersion = "25.11";
          };
        }
      ];

      specialArgs = { inherit inputs system localPkgs username; };

      mkSystem = host: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./hosts/${host}/configuration.nix ] ++ commonModules ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        desktop-nixos = mkSystem "desktop" [];
        laptop-nixos = mkSystem "laptop" [];
        wsl-nixos = mkSystem "wsl" [ nixos-wsl.nixosModules.default ];
      };
    };
}
