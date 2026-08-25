let
  overlayDir = ../overlays;
  overlays = map (f: import (overlayDir + "/${f}")) (
    builtins.attrNames (builtins.readDir overlayDir)
  );
in
{
  flake.overlays.default = final: prev: builtins.foldl' (acc: o: acc // (o final prev)) prev overlays;
}
