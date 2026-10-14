{
  flake.homeModules.tmux =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.tmux = {
        enable = true;
      };

      xdg.configFile."tmux/tmux.conf".source =
        lib.mkForce (config.lib.utils.mkMutableSymlink ./tmux.conf);

      xdg.configFile."tmux/plugins/catppuccin".source =
        "${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin";
    };
}
