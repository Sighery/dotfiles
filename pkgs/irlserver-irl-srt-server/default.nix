{ stdenv, fetchFromGitHub, cmake, irlserver-srt, zlib, openssl, sqlite, lib, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "irlserver-irl-srt-server";
  version = "16a66c531f7a71ef05e47ccfb707f0e1862b30e1";

  src = fetchFromGitHub {
    owner = "IRLServer";
    repo = "irl-srt-server";
    rev = finalAttrs.version;
    hash = "sha256-COhp2LUQogDQNPELA0Pa5B4xSmSnkNkCtLVOXVeIwXE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    irlserver-srt
    zlib
    openssl
    sqlite
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r bin/. $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/IRLServer/irl-srt-server";
    description = "SRT Live Server for low latency streaming with SRTLA/Belabox";
    license = licenses.mit;
    platforms = platforms.all;
  };
})
