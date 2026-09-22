{ secrets, ... }:

let
  nix-serve-port = toString secrets.binaryCache.port;
in
{
  services.ncro.settings.upstreams = [
    {
      url = "http://${secrets.home_lan.loxez_eth}:${nix-serve-port}";
      priority = 50;
      public_key = "loxez-1:1QnDu4loeqB2JFJnd0LXd8kC7mUsGs5/kyh46ewsGi8=";
    }
    {
      url = "http://${secrets.home_lan.tiber_wlp}:${nix-serve-port}";
      priority = 51;
      public_key = "tiber-1:Cz3/k22utsZZo/AngatA1V4JhyUww3oAK1rtg+CxjPU=";
    }
  ];
}
