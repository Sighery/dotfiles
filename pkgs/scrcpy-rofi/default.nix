{ stdenv, makeWrapper, lib, rofi, scrcpy, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "scrcpy-rofi";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp scrcpy-rofi.sh $out/bin/scrcpy-rofi
    chmod +x $out/bin/scrcpy-rofi

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/scrcpy-rofi \
      --set PATH ${lib.makeBinPath ([
        rofi
        scrcpy
      ])}
  '';

  meta = with lib; {
    homepage = "https://github.com/Sighery/dotfiles";
    description = "A Rofi-based manager for scrcpy";
    license = licenses.mit;
    platforms = platforms.linux;
  };
})
