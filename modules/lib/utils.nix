{
  inputs,
  lib,
  ...
}:
{
  flake.homeModules.default = { config, dotfilesDir, ... }: {
    #  credits to ncfavier for this util function
    config.lib.utils = {
      inherit dotfilesDir;
      mkMutableSymlink =
        path:
        config.lib.file.mkOutOfStoreSymlink (
          config.lib.utils.dotfilesDir + lib.strings.removePrefix (toString inputs.self) (toString path)
        );
    };
  };
}
