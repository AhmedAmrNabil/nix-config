{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.fish;
in
{
  options.apps.fish = {
    enable = lib.mkEnableOption "Fish shell with custom configuration";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { ... }:
      {

        programs.fish = {
          enable = true;
          shellAliases = {
            ls = "eza --icons --hyperlink --color=always --group-directories-first";
            clock = "tty-clock -tcDBC 4";
            nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#(hostname)";
            wsl-nix-clean = "sudo nix-env --delete-generations old;sudo nix-collect-garbage -d";
          };
          shellInit = ''
            set -gx EDITOR micro
            set -gx VISUAL micro
            set -gx MICRO_TRUECOLOR 1
            set_catppuccin_fish_theme
          '';
          functions = {
            set_catppuccin_fish_theme = ''
              set colors \
                  fish_color_normal cdd6f4 \
                  fish_color_command 89b4fa \
                  fish_color_param f2cdcd \
                  fish_color_keyword f38ba8 \
                  fish_color_quote a6e3a1 \
                  fish_color_redirection f5c2e7 \
                  fish_color_end fab387 \
                  fish_color_comment 7f849c \
                  fish_color_error f38ba8 \
                  fish_color_gray 6c7086 \
                  fish_color_selection --background=313244 \
                  fish_color_search_match --background=313244 \
                  fish_color_option a6e3a1 \
                  fish_color_operator f5c2e7 \
                  fish_color_escape eba0ac \
                  fish_color_autosuggestion 6c7086 \
                  fish_color_cancel f38ba8 \
                  fish_color_cwd f9e2af \
                  fish_color_user 94e2d5 \
                  fish_color_host 89b4fa \
                  fish_color_host_remote a6e3a1 \
                  fish_color_status f38ba8 \
                  fish_pager_color_progress 6c7086 \
                  fish_pager_color_prefix f5c2e7 \
                  fish_pager_color_completion cdd6f4 \
                  fish_pager_color_description 6c7086

              # Loop over pairs: 1=name, 2=value, repeat
              for i in (seq 1 2 (count $colors))
                  set -l name $colors[$i]
                  set -l value $colors[(math $i + 1)]
                  set -U $name $value
              end
            '';
          };
        };
      };
  };

}
