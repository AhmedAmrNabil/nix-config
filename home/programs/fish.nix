{ config, lib, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --icons --hyperlink --color=always --group-directories-first";
      clock = "tty-clock -tcDBC 4";
      hrs = "home-manager switch --flake ~/dotfiles#(hostname)";
      nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#(hostname)";
      wsl-nix-clean = "sudo nix-env --delete-generations old;sudo nix-collect-garbage -d";
    };
    shellInit = ''
      set -gx EDITOR micro
      set -gx VISUAL micro
      set -gx MICRO_TRUECOLOR 1
    '';
    functions = {
      fish_greeting = ''
        fastfetch
      '';
      starship_transient_prompt_func = ''
        starship module character
      '';
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };

  xdg.configFile."fish/themes" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/fish/themes";
    recursive = true;
  };

}
