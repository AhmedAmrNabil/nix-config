{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-local = {
      url = "path:/home/btngana/coding/nixpkgs";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    libnbtplusplus = {
      url = "github:PrismLauncher/libnbtplusplus";
      flake = false;
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
      username = "btngana";
      configPath = "/home/${username}/dotfiles";

      overlays = (import ./overlays) ++ [
        (
          final: prev:
          import ./packages {
            libnbtplusplus = inputs.libnbtplusplus;
            pkgs = final;
          }
        )
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

      specialArgs = {
        inherit
          inputs
          pkgsLocal
          pkgsUnstable
          system
          username
          configPath
          ;
      };

      # replace nixpkgs modules with local ones
      # for local nixpkgs development
      replaceModules =
        modulePaths:
        [ { disabledModules = modulePaths; } ]
        ++ map (p: "${nixpkgs-local}/nixos/modules/${p}") modulePaths;

      mkSystem =
        host: extraModules: extraSpecialArgs:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs // extraSpecialArgs;
          modules = [
            { nixpkgs.pkgs = pkgs; }
            ./hosts/${host}/configuration.nix
            ./modules
            inputs.hyprland.nixosModules.default
          ]
          ++ replaceModules [
            # "programs/gpu-screen-recorder.nix"
          ]
          ++ extraModules;
        };

      mkHome =
        profile:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules = [
            ./home
            ./home/shared.nix
            ./hosts/${profile}/home.nix
            inputs.spicetify-nix.homeManagerModules.default
            inputs.noctalia.homeModules.default
          ];
        };
    in
    {
      nixosConfigurations = {
        desktop-nixos = mkSystem "desktop" [ ] { };
        laptop-nixos = mkSystem "laptop" [ ] { };
        wsl-nixos = mkSystem "wsl" [ nixos-wsl.nixosModules.default ] { };
        # using nixos home manager module here for the iso
        # as i cannot use home-manager indpendent mode
        iso-nixos = mkSystem "iso" [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs // {
                username = "nixos";
              };
              users.nixos = {
                imports = [
                  ./hosts/iso/home.nix
                  ./home
                  inputs.spicetify-nix.homeManagerModules.default
                ];
              };
            };
          }
        ] { username = "nixos"; };
      };

      homeConfigurations = {
        "${username}@desktop-nixos" = mkHome "desktop";
        "${username}@laptop-nixos" = mkHome "laptop";
        "${username}@wsl-nixos" = mkHome "wsl";
      };

      # for building packages with nix build .#packageName
      packages.${system} = import ./packages {
        pkgs = pkgs;
        libnbtplusplus = inputs.libnbtplusplus;
      };

      devShells.${system}.default = pkgs.mkShell {
        # Required for qmlls to find the correct type declarations
        shellHook = ''
          #bash
          export QML_IMPORT_PATH=${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${pkgs.quickshell}/lib/qt-6/qml/:$PWD/home/apps/quickshell/config/
        '';
      };
    };
}
