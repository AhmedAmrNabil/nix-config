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
      package = pkgsUnstable.vscode.fhs;
      mutableExtensionsDir = true;
    };

    xdg.configFile."Code/User/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/apps/vscode/settings.json";

    xdg.configFile."Code/User/keybindings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/apps/vscode/keybindings.json";
    home.shellAliases = {
      nce = "code --new-window ${config.home.homeDirectory}/dotfiles";
    };
  };
}
