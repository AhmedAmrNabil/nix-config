{ self, ... }:
{
  flake.homeModules.shell = {
    imports = with self.homeModules; [
      fish
      bash
      # zsh
      starship
      fzf
      zoxide
      eza
      bat
      fastfetch
      direnv
      devenv
      yazi
      nix-your-shell
    ];
  };
}
