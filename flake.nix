{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    hilorioze.url = "github:hilorioze/nur-packages";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      home-manager,
      hilorioze,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      overlays = [
        (import ./overlays/xournalpp)
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
      };

      localPkgs = import ./packages {
        inherit pkgs;
      };

      username = "btngana";

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
                  inherit inputs localPkgs system;
                };
                sharedModules = with inputs; [
                  spicetify-nix.homeManagerModules.default
                ];
                backupFileExtension = ".hm-bak";
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
              hilorioze
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
