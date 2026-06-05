{
  config,
  inputs,
  lib,
  ...
}:
{
  #  credits to ncfavier for this util function
  config.lib.utils = {
    configPath = "${config.home.homeDirectory}/dotfiles";
    mkMutableSymlink =
      path:
      config.lib.file.mkOutOfStoreSymlink (
        config.lib.utils.configPath + lib.strings.removePrefix (toString inputs.self) (toString path)
      );
  };
}
