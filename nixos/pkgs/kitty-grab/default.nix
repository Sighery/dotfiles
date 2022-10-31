{ lib, stdenv, fetchFromGitHub, coreutils, kitty }:


stdenv.mkDerivation rec {
  pname = "kitty-grab";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "yurikhan";
    repo = "kitty_grab";
    rev = "741ae3c7b65172f0e3354c43d28d6324c7b4ae59";
    sha256 = "1x13wfgz3mbmvnhnr24inmc7934b4ims9qmrikaly9cmgkp2xsdz";
  };

  buildInputs = [ coreutils kitty ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a _grab_ui.py $out/bin/_grab_ui.py
    cp -a grab.py $out/bin/grab.py
    cp -a kitten_options_definition.py $out/bin/kitten_options_definition.py
    cp -a kitten_options_parse.py $out/bin/kitten_options_parse.py
    cp -a kitten_options_types.py $out/bin/kitten_options_types.py
    cp -a kitten_options_utils.py $out/bin/kitten_options_utils.py
    mkdir -p $out/share/doc/kitty-grab/
    cp -a grab.conf.example $out/share/doc/kitty-grab/grab.conf.example
    cp -a kitty.conf.example $out/share/doc/kitty-grab/kitty.conf.example
  '';

  meta = with lib; {
    description = "Keyboard-driven screen grabber for Kitty";
    homepage = "https://github.com/yurikhan/kitty_grab";
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; linux;
  };
}
