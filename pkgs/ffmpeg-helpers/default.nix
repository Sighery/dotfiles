{ stdenv, makeWrapper, lib, ffmpeg, coreutils, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "ffmpeg-helpers";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp fftomp4.sh $out/bin/fftomp4
    chmod +x $out/bin/fftomp4

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/fftomp4 \
      --set PATH ${lib.makeBinPath ([
        ffmpeg
        coreutils
      ])}
  '';

  meta = with lib; {
    homepage = "https://github.com/Sighery/dotfiles";
    description = "Series of ffmpeg helper scripts for things I need to do often.";
    license = licenses.mit;
    platforms = platforms.all;
  };
})
