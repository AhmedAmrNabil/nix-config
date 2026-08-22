{
  inputs,
  self,
  withSystem,
  ...
}:
let
  username = "btngana";
  homePath = "/home/${username}";
  configPath = "/home/${username}/dotfiles";

  mkSystem =
    system: extraModules: extraSpecialArgs:
    withSystem system (
      {
        pkgs,
        pkgsUnstable,
        pkgsLocal,
        ...
      }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit username;
          inherit pkgsUnstable pkgsLocal;
        }
        // extraSpecialArgs;

        modules = [
          { nixpkgs.pkgs = pkgs; }
          inputs.hyprland.nixosModules.default
        ]
        ++ extraModules;
      }
    );

  mkHome =
    system: extraModules:
    withSystem system (
      {
        pkgs,
        pkgsUnstable,
        pkgsLocal,
        ...
      }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit username;
          inherit pkgsUnstable pkgsLocal;
        };
        modules = [
          inputs.spicetify-nix.homeManagerModules.default
          inputs.noctalia.homeModules.default
          self.homeModules.default
        ]
        ++ extraModules;
      }
    );
in
{
  _module.args = {
    inherit configPath homePath;
  };
  flake.nixosConfigurations = {
    desktop-nixos = mkSystem "x86_64-linux" [ self.nixosModules.desktop-nixos ] { };
    laptop-nixos = mkSystem  "x86_64-linux" [ self.nixosModules.laptop-nixos ] { };
    wsl-nixos = mkSystem "x86_64-linux" [ self.nixosModules.wsl-nixos ] { };
    iso-nixos = mkSystem "x86_64-linux" [
      self.nixosModules.iso
      inputs.home-manager.nixosModules.home-manager
    ] { username = "nixos"; };
  };

  flake.homeConfigurations = {
    "${username}@desktop-nixos" = mkHome "x86_64-linux" [ self.homeModules.desktop-nixos ];
    "${username}@wsl-nixos" = mkHome "x86_64-linux" [ self.homeModules.wsl-nixos ];
    "${username}@laptop-nixos" = mkHome "x86_64-linux" [ self.homeModules.laptop-nixos ];
  };
}
