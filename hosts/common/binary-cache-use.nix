{ secrets, ... }:

{
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "loxez-1:1QnDu4loeqB2JFJnd0LXd8kC7mUsGs5/kyh46ewsGi8="
  ];

  nix.settings.substituters = [
    "https://cache.nixos.org"
  ] ++ secrets.binaryCache.localSubstituters;
}
