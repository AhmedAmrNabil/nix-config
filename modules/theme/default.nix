{ inputs, ... }:
{
  flake.homeModules.catppuccin = {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];
    catppuccin = {
      enable = true;
      autoEnable = true;
      flavor = "mocha";
      accent = "blue";
    };
    catppuccin.vscode.profiles.default.enable = false;
    catppuccin.micro.transparent = true;
  };

  flake.nixosModules.catppuccin = {
    imports = [ inputs.catppuccin.nixosModules.catppuccin ];
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "blue";
    };
    catppuccin.cache.enable = true;
  };
}
