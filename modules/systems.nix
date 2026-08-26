{
  inputs,
  self,
  withSystem,
  lib,
  ...
}:
let
  defaultHost = {
    arch = "x86_64-linux";
    username = "btngana";
    homeDir = "/home/btngana";
    dotfilesDir = "/home/btngana/dotfiles";
    hasStandaloneHome = true;
  };

  hosts = {
    desktop-nixos = defaultHost;
    laptop-nixos = defaultHost;
    wsl-nixos = defaultHost;
    iso-nixos = defaultHost // {
      username = "nixos";
      hasStandaloneHome = false;
    };
  };
in
{
  flake.nixosConfigurations = builtins.mapAttrs (
    name: host:
    withSystem host.arch (
      {
        pkgs,
        pkgsUnstable,
        pkgsLocal,
        ...
      }:
      inputs.nixpkgs.lib.nixosSystem {
        system = host.arch;

        specialArgs = {
          inherit (host) username homeDir dotfilesDir;
          inherit pkgsUnstable pkgsLocal;
        };

        modules = [
          {
            nixpkgs.pkgs = pkgs;
            networking.hostName = name;
          }
          self.nixosModules.${name}
        ];
      }
    )
  ) hosts;

  flake.homeConfigurations = lib.mapAttrs' (name: host: {
    name = "${host.username}@${name}";
    value = withSystem host.arch (
      {
        pkgs,
        pkgsUnstable,
        pkgsLocal,
        ...
      }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit (host) username homeDir dotfilesDir;
          inherit pkgsUnstable pkgsLocal;
        };
        modules = [
          self.homeModules.default
          self.homeModules.${name}
        ];
      }
    );
  }) (lib.filterAttrs (name: host: host.hasStandaloneHome == true) hosts);
}
