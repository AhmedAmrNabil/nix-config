{
  config,
  inputs,
  lib,
  configPath,
  ...
}:
{
  #  credits to ncfavier for this util function
  config.lib.utils = {
    configPath = configPath;
    mkMutableSymlink =
      path:
      config.lib.file.mkOutOfStoreSymlink (
        config.lib.utils.configPath + lib.strings.removePrefix (toString inputs.self) (toString path)
      );
  };
}
