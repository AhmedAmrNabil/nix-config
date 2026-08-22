{
  flake.homeModules.fish =
    { pkgs, ... }:
    let
      catppuccinFish = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/fish/refs/heads/main/themes/catppuccin-mocha.theme";
        hash = "sha256-hLXJH83AkaWcHpikaUGEGZQf5XMlG5rViO0Wb9tOyIw=";
      };
    in
    {
      programs.fish = {
        enable = true;
        shellInit = ''
          fish_config theme choose "catppuccin"
        '';
      };

      xdg.configFile."fish/themes/catppuccin.theme".source = "${catppuccinFish}";
    };
}
