{
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  llvmPackages_22,
  zstd,
  fetchzip,
}:

let
  luato = fetchFromGitHub {
    name = "luato";
    owner = "litocpp";
    repo = "luato";
    rev = "61dd40dca1e9aeda69eed208ddf0d10b34f59db7";
    hash = "sha256-F8q9tHnjnOXGJOMipt63+Bc2y9GSgM2QR4wW+hL30/c="; # nix build will tell you the real one on first try
  };
  rstd = fetchFromGitHub {
    name = "rstd";
    owner = "litocpp";
    repo = "rstd";
    rev = "5b163c47dd044012ae69128fe44aa9311011b250";
    hash = "sha256-IoR+V+McYMT7vAgxXNaTJ8jkVeqghJ6FbVtK6Db/ExY=";
  };
  libcrypto = fetchFromGitHub {
    name = "licrypto";
    owner = "litocpp";
    repo = "licrypto";
    rev = "b7156942a4b85780a21bd11092c08cb6893b05d4";
    hash = "sha256-cPzNHgYvjqhrmqF2Ziv+l6fVE5mGIufTwRofv6dPxfg=";
  };
  lua5_5_1 = fetchzip {
    url = "https://www.lua.org/ftp/lua-5.5.1.tar.gz";
    hash = "sha256-vb3Nt5dMPL/G6L1MmJPGQnQT3F8p6iK6Gu2F/cG00ho=";
    stripRoot = true;
  };
in
llvmPackages_22.libcxxStdenv.mkDerivation (finalAttrs: {
  pname = "lito";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "litocpp";
    repo = "lito";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rHHKrq9EWVWlh62HAftym+HqbxFHWxGpw2/YCfEVeYo=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    llvmPackages_22.bintools
    llvmPackages_22.clang-tools
  ];

  buildInputs = [
    zstd
  ];

  preBuild = ''
    export CXXFLAGS="''${CXXFLAGS//-Wp,-D_FORTIFY_SOURCE=3/}"
  '';

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LUATO" "${luato}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_RSTD" "${rstd}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LICRYPTO" "${libcrypto}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LUA" "${lua5_5_1}")
    (lib.cmakeBool "LITO_USE_SYSTEM_ZSTD" true)
  ];

  hardeningDisable = [ "fortify" ];

  cmakeBuildType = "Release";
  buildFlags = [ "lito" ];
  doCheck = false;

  meta = with lib; {
    description = "Module-first C++ build tool with manifest";
    homepage = "https://github.com/litocpp/lito";
    license = [
      licenses.mit
      licenses.asl20
    ];
    platforms = platforms.unix;
    mainProgram = "lito";
  };
})
