{ stdenv, makeWrapper, lib, wireplumber, bc, gawk, coreutils, gnused, libnotify, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "audio-notification";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp audio_notification.sh $out/bin/audio-notification
    chmod +x $out/bin/audio-notification

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/audio-notification \
      --set PATH ${lib.makeBinPath ([
        wireplumber
        bc
        gawk
        coreutils
        gnused
        libnotify
      ])}
  '';

  meta = with lib; {
    homepage = "https://github.com/Sighery/dotfiles";
    description = "Small helper script to display current volume and mute status on the default audio sink.";
    license = licenses.mit;
    platforms = platforms.all;
  };
})
