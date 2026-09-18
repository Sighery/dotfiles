{ stdenvNoCC, fetchurl, gnused, lib, ... }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vscode-antislop-settings";
  version = "2a8fb23de3c44ecdd78bf5777da5d6db4b9ebe90";

  src = fetchurl {
    url = "https://gist.githubusercontent.com/rpavlik/95d6c40d8407805e2c20bdf6d9efa44e/raw/${finalAttrs.version}/settings.json";
    hash = "sha256-/3RF2DkiKkqhhwCFHCJP0o+oWX2zWj2EuYHyO8bR1Co=";
  };

  nativeBuildInputs = [
    gnused
  ];

  unpackPhase = ''
    runHook preUnpack

    mkdir -p "$out"
    cp "$src" "$out/settings.json"

    runHook postUnpack
  '';

  postPatch = ''
    sed -i '/^\s*\/\/ /d' "$out/settings.json"
    substituteInPlace "$out/settings.json" \
      --replace-fail '"geminicodeassist.chat.automaticScrolling": false,' \
        '"geminicodeassist.chat.automaticScrolling": false'
  '';

  meta = with lib; {
    homepage = "https://gist.github.com/rpavlik/95d6c40d8407805e2c20bdf6d9efa44e";
    description = "Go away copilot and other slop machines (in vscode)";
    license = licenses.mit;
    platforms = platforms.all;
  };
})
