{ config, pkgs, inputs, ... }:

{
  sops.secrets."networkmanager/wifi/home/ssid" = {
    sopsFile = "${inputs.dotfiles-secrets}/secrets/common/networking-wireless.yaml";
  };
  sops.secrets."networkmanager/wifi/home/psk" = {
    sopsFile = "${inputs.dotfiles-secrets}/secrets/common/networking-wireless.yaml";
  };
  sops.secrets."networkmanager/wifi/work/ssid" = {
    sopsFile = "${inputs.dotfiles-secrets}/secrets/common/networking-wireless.yaml";
  };
  sops.secrets."networkmanager/wifi/work/psk" = {
    sopsFile = "${inputs.dotfiles-secrets}/secrets/common/networking-wireless.yaml";
  };

  systemd.network.wait-online.enable = false;

  environment.systemPackages = [
    pkgs.networkmanagerapplet
  ];

  networking.networkmanager = {
    enable = true;

    plugins = with pkgs; [
      networkmanager-fortisslvpn
      networkmanager-l2tp
      networkmanager-strongswan
    ];

    ensureProfiles = {
      environmentFiles = [
        config.sops.secrets."networkmanager/wifi/home/ssid".path
        config.sops.secrets."networkmanager/wifi/home/psk".path
        config.sops.secrets."networkmanager/wifi/work/ssid".path
        config.sops.secrets."networkmanager/wifi/work/psk".path
      ];

      profiles = {
        "home" = {
          connection = {
            id = "home";
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

        "work" = {
          connection = {
            id = "work";
            type = "wifi";
            autoconnect = true;
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$WORK_SSID";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$WORK_PSK";
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
