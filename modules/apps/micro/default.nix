{
  flake.homeModules.micro =
    { pkgs, ... }:
    let
      catppuccin-micro = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "micro";
        rev = "015a2bb208f61a2d5a33121de2644bf4a059436b";
        hash = "sha256-XbhUwRz21/XLkdOb6VOqLwzxWtehf6qRms0YcepNQ0s=";
      };
    in
    {
      programs.micro = {
        enable = true;
        settings = {
          colorscheme = "catppuccin-mocha-transparent";
        };
      };

      home.sessionVariables = {
        EDITOR = "micro";
        VISUAL = "micro";
      };

      xdg.configFile."micro/colorschemes/catppuccin-mocha-transparent.micro".source =
        "${catppuccin-micro}/themes/catppuccin-mocha-transparent.micro";
      xdg.configFile."micro/colorschemes/catppuccin-mocha.micro".source =
        "${catppuccin-micro}/themes/catppuccin-mocha.micro";
    };
}
