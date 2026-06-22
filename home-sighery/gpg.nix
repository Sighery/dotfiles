{ ... }:

{
  programs.gpg = {
    enable = true;

    settings = {
      keyid-format = "0xlong";
      with-fingerprint = true;
      with-subkey-fingerprints = true;
      with-keygrip = true;
      use-agent = true;
      keyserver = "eu.pool.sks-keyservers.net";
      local-user = "9454A24E1B5E963078B6E9317C02D10683ADCFB8";
    };
  };

  services.gpg-agent = {
    enable = true;

    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
  };
}
