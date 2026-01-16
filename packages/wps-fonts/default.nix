{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "wpsoffice-fonts";
  version = "2.0";
  src = pkgs.fetchgit {
    url = "https://github.com/dv-anomaly/ttf-wps-fonts";
    rev = "8c980c24289cb08e03f72915970ce1bd6767e45a";
    sha256 = "sha256-x+grMnpEGLkrGVud0XXE8Wh6KT5DoqE6OHR+TS6TagI=";
  };

  buildInputs = [ ];

  buildPhase = "true";

  installPhase = ''
    install -Dm644 $src/*.{ttf,TTF} -t $out/share/fonts/truetype
  '';

  meta = {
    description = "These are the symbol fonts required by wps-office. They are used to display math formulas. We have collected the fonts here to make things easier.";
    homepage = "https://github.com/dv-anomaly/ttf-wps-fonts";
    binaryDistribution = false;
    priority = 5;
  };
}
