{ lib, stdenv, fetchFromGitHub, bash, coreutils, gawk, wireplumber, bc, makeWrapper }:


stdenv.mkDerivation rec {
  pname = "audio-notification";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "Sighery";
    repo = "audio-notification";
    rev = "b4f63372d3d5cf0140ea9ae4be07a4435e1349bb";
    sha256 = "OjujJMhrqFugeGQg+jJbjIGCspDfpE7YJNpkwaAMXa0=";
  };

  buildInputs = [ coreutils bash ];
  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a audio_notification.sh $out/bin/audio-notification
    chmod +x $out/bin/audio-notification
    wrapProgram $out/bin/audio-notification \
      --prefix PATH : ${ lib.makeBinPath [ bash wireplumber bc gawk ] }
  '';

  meta = with lib; {
    description = "Notification with current audio status";
    homepage = "https://github.com/Sighery/audio-notification";
    platforms = with lib.platforms; linux;
  };
}
