{ stdenv, fetchurl, makeWrapper, jre_headless, lib, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "vineflower";
  version = "1.12.0";

  src = fetchurl {
    url = "https://github.com/Vineflower/${finalAttrs.pname}/releases/download/${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.jar";
    sha256 = "sha256-Hfz+l0OVc0+kZ85iBmHHYj0FuoNnDeBSmx+9Y/9Ui50=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre_headless ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp $src $out/share/java/vineflower.jar

    mkdir -p $out/bin
    makeWrapper ${jre_headless}/bin/java $out/bin/vineflower \
      --add-flags "-jar $out/share/java/vineflower.jar"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Vineflower/vineflower";
    description = "Modern Java decompiler aiming to be as accurate as possible, with an emphasis on output quality. Fork of the Fernflower decompiler.";
    license = licenses.asl20;
    platforms = platforms.all;
  };
})
