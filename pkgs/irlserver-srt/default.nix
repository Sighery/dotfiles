{ stdenv, fetchFromGitHub, cmake, tcl, openssl, lib, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "irlserver-srt";
  version = "f2297192ce9ab572464e84228efbc46f8c1eabf4";

  src = fetchFromGitHub {
    owner = "irlserver";
    repo = "srt";
    rev = finalAttrs.version;
    hash = "sha256-1X5bpdgb9VL8/JgdCRQtVyrR+SwO7vtM/MnMxl+GIjY=";
  };

  nativeBuildInputs = [
    cmake
    tcl
  ];

  buildInputs = [
    openssl
  ];

  configureScript = "./configure";

  # https://github.com/nh2/nixpkgs/blob/f7b53c0f6a42aa1aaa23628fd44891ad4102f9df/pkgs/development/libraries/srt/default.nix#L20-L29
  cmakeFlags = [
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-UCMAKE_INSTALL_LIBDIR"
  ];

  meta = with lib; {
    homepage = "https://github.com/irlserver/srt";
    description = "Up-to-date fork of the srt shared library with BELABOX changes";
    license = licenses.mpl20;
    platforms = platforms.all;
  };
})
