{ config, pkgs, secrets, ... }:

{
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;

    port = secrets.binaryCache.port;
    openFirewall = true;

    secretKeyFile = config.sops.secrets."binary_cache".path;

    extraParams = "--priority 50";
  };
}
