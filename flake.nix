{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    hyprland.url = "github:hyprwm/Hyprland";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
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

      pkgs = import nixpkgs {
        inherit system overlays;
      };
      pkgsUnstable = import inputs.nixpkgs-unstable {
        inherit system overlays;
        config.allowUnfree = true;
      };

      localPkgs = import ./packages {
        inherit pkgs;
      };

      username = "btngana";

      gitConfig = {
        userName = "AhmedAmrNabil";
        userEmail = "ahmedamr24680@gmail.com";
      };

      mkSystem =
        host:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${host}/configuration.nix
            ./modules
            # Apply overlays to NixOS
            { nixpkgs.overlays = overlays; }
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit
                    inputs
                    localPkgs
                    system
                    pkgsUnstable
                    gitConfig
                    ;
                };
                sharedModules = with inputs; [
                  spicetify-nix.homeManagerModules.default
                ];
                backupFileExtension = "hm-bak";
                users.${username}.home.stateVersion = "25.11";
              };
            }
          ]
          ++ (if host == "wsl" then [ nixos-wsl.nixosModules.default ] else [ ]);
          specialArgs = {
            inherit
              inputs
              system
              localPkgs
              username
              ;
          };
        };
    in
    {
      nixosConfigurations = {
        desktop-nixos = mkSystem "desktop";
        laptop-nixos = mkSystem "laptop";
        wsl-nixos = mkSystem "wsl";
      };
    };
}
