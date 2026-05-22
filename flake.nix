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

      overlays = (import ./overlays) ++ [
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

      specialArgs = {
        inherit
          inputs
          pkgsLocal
          pkgsUnstable
          system
          username
          ;
      };

      # replace nixpkgs modules with local ones
      # for local nixpkgs development
      replaceModules =
        modulePaths:
        [ { disabledModules = modulePaths; } ]
        ++ map (p: "${nixpkgs-local}/nixos/modules/${p}") modulePaths;

      mkSystem =
        host: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
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
            ./hosts/${profile}/home.nix
            ./home
            inputs.spicetify-nix.homeManagerModules.default
          ];
        };
    in
    {
      nixosConfigurations = {
        desktop-nixos = mkSystem "desktop" [
          {
            virtualisation.vmVariant = {
              de.kde.autoLogin = pkgs.lib.mkForce false;
              users.users."${username}".password = "password"; # just for the vm, not used anywhere else
              virtualisation.memorySize = 8192; # 8GB
              virtualisation.cores = 4;
              virtualisation.qemu.options = [
                "-vga none"
                "-device virtio-vga-gl"
                "-display gtk,gl=on"
              ];
            };
          }
        ];
        laptop-nixos = mkSystem "laptop" [ ];
        wsl-nixos = mkSystem "wsl" [ nixos-wsl.nixosModules.default ];
      };

      homeConfigurations = {
        "${username}@desktop-nixos" = mkHome "desktop";
        "${username}@laptop-nixos" = mkHome "laptop";
        "${username}@wsl-nixos" = mkHome "wsl";
      };

      # for building packages with nix build .#packageName
      packages.${system} = import ./packages { pkgs = pkgs; };
    };
}
