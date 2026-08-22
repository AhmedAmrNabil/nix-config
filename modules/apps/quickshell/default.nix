{
  flake.homeModules.quickshell =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.quickshell.enable = true;
      qt.enable = true;
      home.packages = [ pkgs.kdePackages.qtdeclarative ];
      xdg.configFile."quickshell".source = lib.mkForce (config.lib.utils.mkMutableSymlink ./config);
    };
}
