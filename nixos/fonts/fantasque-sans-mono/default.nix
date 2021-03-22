{ lib, fetchzip }:

let
  version = "1.7.2";
in

fetchzip rec {
  name = "fantasque-sans-mono-${version}";

  url = "https://github.com/belluzj/fantasque-sans/releases/download/v${version}/FantasqueSansMono-LargeLineHeight-NoLoopK.zip";

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.otf    -d $out/share/fonts/opentype
    unzip -j $downloadedFile README.md -d $out/share/doc/${name}
  '';

  sha256 = "1myp4gdxx91jn29vw90z4yiwyahzj5qh29pjlmkknzpdycdb08b5";

  meta = with lib; {
    homepage = "https://github.com/belluzj/fantasque-sans";
    description = "A font family with a great monospaced variant for programmers";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
