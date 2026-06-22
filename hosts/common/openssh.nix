{ ... }:

{
  services.openssh = {
    enable = true;

    generateHostKeys = true;
    enableRecommendedAlgorithms = true;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
