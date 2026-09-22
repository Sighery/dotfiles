{ secrets, ... }:

{
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "loxez-1:1QnDu4loeqB2JFJnd0LXd8kC7mUsGs5/kyh46ewsGi8="
    "tiber-1:Cz3/k22utsZZo/AngatA1V4JhyUww3oAK1rtg+CxjPU="
    # TODO: Remove ncro cache once merged to nixpkgs
    "cache.manic.systems-1:s6OZanN8Us8vRi0jVivP3qlMn0cYHBjBALKrNe5nH8s="
  ];
}
