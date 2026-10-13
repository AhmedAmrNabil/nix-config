{ lib, ... }:
let
  overlayDir = ../overlays;
  overlays = map (f: import (overlayDir + "/${f}")) (
    builtins.attrNames (builtins.readDir overlayDir)
  );
in
{
  flake.overlays.default = lib.composeManyExtensions overlays;
}
