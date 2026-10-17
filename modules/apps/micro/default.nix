{
  flake.homeModules.micro =
    { config, lib, ... }:
    let
      cfg = config.catppuccin.micro;
      base = "catppuccin-${cfg.flavor}" + lib.optionalString cfg.transparent "-transparent";
    in
    {
      programs.micro = {
        enable = true;
        settings.colorscheme = lib.mkForce "${base}-nix";
      };

      xdg.configFile."micro/colorschemes/${base}-nix.micro".text = ''
        include "${base}"

        color-link identifier.value      "#cdd6f4"
        color-link identifier.attribute  "#89b4fa"
        color-link identifier.param      "italic #eba0ac"
        color-link identifier.function   "italic #89b4fa"
        color-link constant.language     "#f38ba8"
        color-link constant.string.path  "#f5c2e7"
        color-link constant.specialChar  "#f5c2e7"
        color-link symbol.operator       "#94e2d5"
        color-link symbol.punctuation    "#9399b2"
      '';

      xdg.configFile."micro/syntax/nix.yaml".source = ./nix.yaml;

      home.sessionVariables = {
        EDITOR = "micro";
        VISUAL = "micro";
      };
    };
}
