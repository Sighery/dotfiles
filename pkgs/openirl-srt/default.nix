{ stdenv, fetchFromGitHub, cmake, openssl, lib, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "openirl-srt";
  version = "1.5.4+openirl.1";

  src = fetchFromGitHub {
    owner = "OpenIRL";
    repo = "srt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-geHIFEAUGKrU2R4I8QAL/3BzJncrgglYQKe3boKWagI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    openssl
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DENABLE_SHARED=ON"

    # https://github.com/nh2/nixpkgs/blob/f7b53c0f6a42aa1aaa23628fd44891ad4102f9df/pkgs/development/libraries/srt/default.nix#L20-L29
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-UCMAKE_INSTALL_LIBDIR"
  ];

  meta = with lib; {
    homepage = "https://github.com/OpenIRL/srt";
    description = "Secure, Reliable, Transport";
    license = licenses.mpl20;
    platforms = platforms.all;
  };
})
