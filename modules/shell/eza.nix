{
  flake.homeModules.eza =
    {
      pkgs,
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
