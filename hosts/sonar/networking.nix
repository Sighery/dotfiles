{ config, pkgs, inputs, ... }:

{
  sops.secrets."networkmanager/wifi/work_ssid" = { };
  sops.secrets."networkmanager/wifi/work_psk" = { };
  sops.secrets."networkmanager/vpn/gateway" = { };
  sops.secrets."networkmanager/vpn/user" = { };
  sops.secrets."networkmanager/vpn/password" = { };
  sops.secrets."networkmanager/vpn/ipsec_psk" = { };

  networking.networkmanager.plugins = with pkgs; [
    networkmanager-fortisslvpn
    networkmanager-l2tp
    networkmanager-strongswan
  ];

  networking.networkmanager.ensureProfiles.environmentFiles = [
    config.sops.secrets."networkmanager/wifi/work_ssid".path
    config.sops.secrets."networkmanager/wifi/work_psk".path
    config.sops.secrets."networkmanager/vpn/gateway".path
    config.sops.secrets."networkmanager/vpn/user".path
    config.sops.secrets."networkmanager/vpn/password".path
    config.sops.secrets."networkmanager/vpn/ipsec_psk".path
  ];

  networking.networkmanager.ensureProfiles.profiles."Work Wifi" = {
    connection = {
      id = "work_wifi";
      type = "wifi";
      autoconnect = true;
      autoconnect-priority = 300;
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
      route-metric = 10;
      dns-priority = 1;
    };
    ipv6 = {
      method = "auto";
      addr-gen-mode = "stable-privacy";
    };
  };

  networking.networkmanager.ensureProfiles.profiles."Work VPN" = {
    connection = {
      id = "work_vpn";
      type = "vpn";
      permissions = "user:sighery:;";
      autoconnect = false;
    };
    ipv4 = {
      method = "auto";
    };
    ipv6 = {
      method = "disabled";
    };
    vpn = {
      gateway = "$VPN_GATEWAY";
      ipsec-enabled = "yes";
      ipsec-psk-flags = "0";
      machine-auth-type = "psk";
      machine-certpass-flags = "0";
      mru = "1400";
      mtu = "1400";
      password-flags = "0";
      service-type = "org.freedesktop.NetworkManager.l2tp";
      user = "$VPN_USER";
      user-auth-type = "password";
    };
    vpn-secrets = {
      password = "$VPN_PASSWORD";
      ipsec-psk = "$VPN_IPSEC_PSK";
    };
  };
}
