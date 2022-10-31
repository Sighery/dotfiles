{ lib, stdenv, fetchFromGitHub, bash, coreutils, gawk, libpulseaudio, alsaLib }:


stdenv.mkDerivation rec {
  pname = "i3-volume";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "hastinbe";
    repo = "i3-volume";
    rev = "v${version}";
    sha256 = "1xihl6h6grqgk7qll1knqvxnryfqni6317lrlbww0sk71l3w0ryv";
  };

  buildInputs = [ coreutils bash gawk libpulseaudio alsaLib ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a volume $out/bin/i3-volume
    chmod +x $out/bin/i3-volume
    mkdir -p $out/share/doc/i3-volume/
    cp -a i3volume-alsa.conf $out/share/doc/i3-volume/i3volume-alsa.conf
    cp -a i3volume-pulseaudio.conf $out/share/doc/i3-volume/i3volume-pulseaudio.conf
  '';

  meta = with lib; {
    description = "Volume control and volume notifications";
    homepage = "https://github.com/hastinbe/i3-volume";
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux;
  };
}
