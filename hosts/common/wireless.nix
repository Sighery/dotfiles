{ config, pkgs, secrets, ... }:

{
  sops.secrets."wireless" = {
    sopsFile = "${secrets}/secrets/common/networking-wireless.yaml";
    owner = "wpa_supplicant";
    mode = "0400";
  };

  networking.wireless = {
    enable = true;
    userControlled = true;

    secretsFile = config.sops.secrets."wireless".path;

    networks = {
      "${secrets.wireless.home_ssid}" = {
        pskRaw = "ext:home_psk";
      };
    };
  };
}
