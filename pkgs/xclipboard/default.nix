{ stdenv, makeWrapper, lib, xclip, coreutils, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "xclipboard";
  version = "0.3.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp xclipboard.sh $out/bin/xclipboard
    chmod +x $out/bin/xclipboard

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/xclipboard \
      --set PATH ${lib.makeBinPath ([
        xclip
        coreutils
      ])}
  '';

  meta = with lib; {
    homepage = "https://github.com/Sighery/dotfiles";
    description = "Helper script to copy files to clipboard from CLI.";
    license = licenses.mit;
    platforms = platforms.all;
  };
})
