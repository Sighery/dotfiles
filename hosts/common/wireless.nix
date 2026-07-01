{ config, inputs, ... }:

{
  sops.secrets."wireless" = {
    sopsFile = "${inputs.dotfiles-secrets}/secrets/common/networking-wireless.yaml";
    owner = "wpa_supplicant";
    mode = "0400";
  };

  networking.wireless = {
    enable = true;
    userControlled = true;

    secretsFile = config.sops.secrets."wireless".path;

    networks = {
      "${inputs.dotfiles-secrets.wireless.home_ssid}" = {
        pskRaw = "ext:home_psk";
      };
      "${inputs.dotfiles-secrets.wireless.work_ssid}" = {
        pskRaw = "ext:work_psk";
      };
    };
  };
}
