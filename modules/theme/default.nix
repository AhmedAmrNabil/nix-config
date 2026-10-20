{ inputs, ... }:
{
  flake.nixosModules.catppuccin = { inputs', ... }: {
    imports = [ inputs.catppuccin.nixosModules.catppuccin ];
    environment.systemPackages = [
      inputs'.catppuccin.packages.default
    ];
    catppuccin = {
      enable = true;
      autoEnable = false;
      flavor = "mocha";
      accent = "blue";
      cache.enable = true;
      fish.enable = true;
    };
  };

  flake.homeModules.catppuccin = {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];
    catppuccin = {
      enable = true;
      autoEnable = true;
      flavor = "mocha";
      accent = "blue";
      vscode.profiles.default.enable = false;
      micro.transparent = true;
    };
  };
}
