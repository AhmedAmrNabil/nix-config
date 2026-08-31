{
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "my-package";
  version = "0.1.0";

  src = ./.;

  meta = {
    description = "A simple package";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "my-package";
    platforms = lib.platforms.linux;
  };
}
