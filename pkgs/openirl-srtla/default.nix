{ stdenv, fetchFromGitHub, cmake, python3, spdlog, argparse, lib, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "openirl-srtla";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "OpenIRL";
    repo = "srtla";
    rev = finalAttrs.version;
    hash = "sha256-Q6gi046dAsjK2AklAsXrYAkDJiqnhYouZuCDnKZijmw=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    spdlog
    argparse
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m 755 srtla_rec $out/bin/srtla_rec

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/OpenIRL/srtla";
    description = "SRT transport proxy with link aggregation for connection bonding";
    license = licenses.agpl3Plus;
    platforms = platforms.all;
  };
})
