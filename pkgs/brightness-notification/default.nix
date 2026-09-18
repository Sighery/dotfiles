{ stdenv, makeWrapper, lib, brightnessctl, coreutils, libnotify, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "brightness-notification";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp brightness_notification.sh $out/bin/brightness-notification
    chmod +x $out/bin/brightness-notification

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/brightness-notification \
      --set PATH ${lib.makeBinPath ([
        brightnessctl
        coreutils
        libnotify
      ])}
  '';

  meta = with lib; {
    homepage = "https://github.com/Sighery/dotfiles";
    description = "Small helper script to display current brightness.";
    license = licenses.mit;
    platforms = platforms.all;
  };
})
