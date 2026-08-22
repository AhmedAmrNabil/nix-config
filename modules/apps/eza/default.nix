{
  flake.homeModules.eza =
    {
      pkgs,
      config,
      ...
    }:
    {
      programs.eza = {
        enable = true;
        icons = "always";
        extraOptions = [
          "--hyperlink"
          "--color=always"
          "--group-directories-first"
        ];
        enableFishIntegration = config.programs.fish.enable;
        enableBashIntegration = config.programs.bash.enable;
        git = true;
      };
      programs.fish.plugins = [
        {
          name = "eza-remove-default-ls-completion";
          src = pkgs.writeTextDir "completions/ls.fish" "";
        }
      ];
      home.shellAliases = {
        tree = "eza --tree";
      };
    };
}
