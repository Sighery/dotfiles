final: prev:
{
  fantasque-sans-mono = prev.fantasque-sans-mono.overrideAttrs (old: {
    version = "1.7.2";

    src = prev.fetchzip {
      url = "https://github.com/belluzj/fantasque-sans/releases/download/v1.7.2/FantasqueSansMono-LargeLineHeight-NoLoopK.zip";
      stripRoot = false;
      hash = "sha256-/vfThWY+ig/5yeljEQNjpBIMQQQ84wZa0as+kUv4KXA=";
    };
  });
}
