{ config, pkgs, inputs, ... }:

{
  sops.secrets."networkmanager/wifi/home/ssid" = {
    sopsFile = "${inputs.dotfiles-secrets}/secrets/common/networking-wireless.yaml";
  };
  sops.secrets."networkmanager/wifi/home/psk" = {
    sopsFile = "${inputs.dotfiles-secrets}/secrets/common/networking-wireless.yaml";
  };

  systemd.network.wait-online.enable = false;

  environment.systemPackages = [
    pkgs.networkmanagerapplet
    pkgs.networkmanager_dmenu
  ];

  networking.networkmanager = {
    enable = true;

    ensureProfiles = {
      environmentFiles = [
        config.sops.secrets."networkmanager/wifi/home/ssid".path
        config.sops.secrets."networkmanager/wifi/home/psk".path
      ];

      profiles = {
        "Home Wifi" = {
          connection = {
            id = "home_wifi";
            type = "wifi";
            autoconnect = true;
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$HOME_SSID";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$HOME_PSK";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            method = "auto";
            addr-gen-mode = "stable-privacy";
          };
        };
      };
    };
  };
}
