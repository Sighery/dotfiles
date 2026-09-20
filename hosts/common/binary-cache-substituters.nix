{ secrets, ... }:

{
  nix.settings.substituters = [
    "https://cache.nixos.org"
  ] ++ secrets.binaryCache.localSubstituters;
}
