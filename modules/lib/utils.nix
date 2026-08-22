{
  inputs,
  lib,
  configPath,
  ...
}:
{
  flake.homeModules.default = { config, ... }: {
    #  credits to ncfavier for this util function
    config.lib.utils = {
      inherit configPath;
      mkMutableSymlink =
        path:
        config.lib.file.mkOutOfStoreSymlink (
          config.lib.utils.configPath + lib.strings.removePrefix (toString inputs.self) (toString path)
        );
    };
  };
}
