{ config, pkgs, inputs, ... }:

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
    };
  };

  environment.systemPackages = with pkgs; [
    wpa_supplicant_gui
  ];
}
