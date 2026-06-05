{
  config,
  pkgsUnstable,
  lib,
  ...
}:
let
  cfg = config.apps.vscode;
in
{
  options.apps.vscode = {
    enable = lib.mkEnableOption "VSCode with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgsUnstable.vscode;
      mutableExtensionsDir = true;
    };

    xdg.configFile."Code/User/settings.json".source = config.lib.utils.mkMutableSymlink ./settings.json;

    xdg.configFile."Code/User/keybindings.json".source =
      config.lib.utils.mkMutableSymlink ./keybindings.json;

    home.shellAliases = {
      nce = "code --new-window ${config.lib.utils.configPath}";
    };
  };
}
