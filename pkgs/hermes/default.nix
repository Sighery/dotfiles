{ stdenv, fetchFromGitHub, cmake, ninja, python3, icu, readline, tzdata, lib, ... }:

stdenv.mkDerivation {
  pname = "hermes";
  version = "rn/0.84-stable";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "hermes";
    rev = "refs/heads/rn/0.84-stable";
    hash = "sha256-qkc92z42KUTeGScrrKJNNzTb9JT6eqmC89PSUP4w9pY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  buildInputs = [
    icu
    readline
    tzdata
  ];

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m 755 bin/hermes $out/bin
    install -m 755 bin/hermesc $out/bin
    install -m 755 bin/hdb $out/bin
    install -m 755 bin/hbcdump $out/bin
    install -m 755 bin/hvm $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/facebook/hermes";
    description = "A JavaScript engine optimized for running React Native";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
