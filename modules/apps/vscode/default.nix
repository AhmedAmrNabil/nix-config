{
  flake.homeModules.vscode =
    {
      config,
      pkgsUnstable,
      dotfilesDir,
      ...
    }:
    {
      programs.vscode = {
        enable = true;
        package = pkgsUnstable.vscode;
        mutableExtensionsDir = true;
      };

      xdg.configFile."Code/User/settings.json".source = config.lib.utils.mkMutableSymlink ./settings.json;

      xdg.configFile."Code/User/keybindings.json".source =
        config.lib.utils.mkMutableSymlink ./keybindings.json;

      home.shellAliases = {
        nce = "code --new-window ${dotfilesDir}";
      };
    };
}
