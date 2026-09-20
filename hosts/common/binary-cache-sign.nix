{ config, ... }:

{
  sops.secrets."binary_cache" = {
    mode = "0400";
  };

  nix.settings.secret-key-files = [
    config.sops.secrets."binary_cache".path
  ];
}
