# Taken from https://github.com/NL-TCH/nur-packages/blob/bcba7e4cf0f28a60630df8e2b56dc37b94e06d2b/pkgs/spotify-adblock/default.nix
{ rustPlatform, fetchFromGitHub, lib, ... }:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spotify-adblock";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "abba23";
    repo = "spotify-adblock";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = false;
    hash = "sha256-R1xM/a+EzFd3I94EVCphbW+M114x6CtIeCOi9Fd9tpc=";
  };

  cargoHash = "sha256-gxGetdqaoJa/ZF1VnW6UXJyJfLBGZxZnyKpT/Qk/8Og=";

  patchPhase = ''
    substituteInPlace src/config.rs \
      --replace 'config.toml' $out/etc/spotify-adblock/config.toml
  '';

  buildPhase = ''
    runHook preBuild

    make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/etc/spotify-adblock
    install -D --mode=644 config.toml $out/etc/spotify-adblock
    mkdir -p $out/lib
    install -D --mode=644 --strip target/release/libspotifyadblock.so $out/lib

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/abba23/spotify-adblock";
    description = "Adblocker for Spotify";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
})
