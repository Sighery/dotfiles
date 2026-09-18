{ stdenv, fetchFromGitHub, lib, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "kitty-grab";
  version = "969e363295b48f62fdcbf29987c77ac222109c41";

  src = fetchFromGitHub {
    owner = "yurikhan";
    repo = "kitty_grab";
    rev = finalAttrs.version;
    hash = "sha256-DamZpYkyVjxRKNtW5LTLX1OU47xgd/ayiimDorVSamE=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -a *.py $out/bin/.

    mkdir -p $out/share/doc/kitty-grab/
    cp -a *.conf.example $out/share/doc/kitty-grab/.

    runHook postInstall
  '';

  meta = with lib; {
    description = "Keyboard-driven screen grabber for Kitty";
    homepage = "https://github.com/yurikhan/kitty_grab";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
})
