{ stdenv, fetchFromGitHub, cmake, python3, spdlog, argparse, lib, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "irlserver-srtla";
  version = "39e324a9420763720b9f16c463971ababa757bc1";

  src = fetchFromGitHub {
    owner = "irlserver";
    repo = "srtla";
    rev = finalAttrs.version;
    hash = "sha256-pb3SrhqzHoLdovjR802pf33jFgpYvybN9NsBfh3rQZk=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    spdlog
    argparse
  ];

  patches = [
    ./dynamic-spdlog.diff
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m 755 srtla_rec $out/bin/srtla_rec
    install -m 755 srtla_send $out/bin/srtla_send

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/irlserver/srtla";
    description = "SRT transport proxy with link aggregation for connection bonding";
    license = licenses.agpl3Plus;
    platforms = platforms.all;
  };
})
