{ config, lib, pkgs, secrets, ... }:

{
  sops.secrets."networkmanager/wifi/work_ssid" = { };
  sops.secrets."networkmanager/wifi/work_psk" = { };

  sops.secrets."networkmanager/vpn/l2tp/gateway" = { };
  sops.secrets."networkmanager/vpn/l2tp/user" = { };
  sops.secrets."networkmanager/vpn/l2tp/password" = { };
  sops.secrets."networkmanager/vpn/l2tp/ipsec_psk" = { };

  sops.secrets."networkmanager/vpn/openvpn/remote" = { };
  sops.secrets."networkmanager/vpn/openvpn/username" = { };
  sops.secrets."networkmanager/vpn/openvpn/cert_pass" = { };
  sops.secrets."networkmanager/vpn/openvpn/password" = { };
  sops.secrets."networkmanager/vpn/openvpn/cipher" = { };
  sops.secrets."networkmanager/vpn/openvpn/ca" = { };
  sops.secrets."networkmanager/vpn/openvpn/cert" = { };
  sops.secrets."networkmanager/vpn/openvpn/key" = { };

  networking.networkmanager.plugins = with pkgs; [
    networkmanager-fortisslvpn
    networkmanager-l2tp
    networkmanager-strongswan
    networkmanager-openvpn
  ];

  networking.networkmanager.ensureProfiles.environmentFiles = [
    config.sops.secrets."networkmanager/wifi/work_ssid".path
    config.sops.secrets."networkmanager/wifi/work_psk".path

    config.sops.secrets."networkmanager/vpn/l2tp/gateway".path
    config.sops.secrets."networkmanager/vpn/l2tp/user".path
    config.sops.secrets."networkmanager/vpn/l2tp/password".path
    config.sops.secrets."networkmanager/vpn/l2tp/ipsec_psk".path

    config.sops.secrets."networkmanager/vpn/openvpn/remote".path
    config.sops.secrets."networkmanager/vpn/openvpn/username".path
    config.sops.secrets."networkmanager/vpn/openvpn/cert_pass".path
    config.sops.secrets."networkmanager/vpn/openvpn/password".path
    config.sops.secrets."networkmanager/vpn/openvpn/cipher".path
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

  networking.networkmanager.ensureProfiles.profiles."Work L2TP" =
    lib.recursiveUpdate secrets.sonar.nm_config.work_l2tp {
      connection = {
        id = "work_l2tp";
        type = "vpn";
        permissions = "user:sighery:;";
        autoconnect = false;
      };
      ipv4 = {
        method = "auto";
        never-default = true;
      };
      ipv6 = {
        method = "disabled";
      };
      vpn = {
        gateway = "$L2TP_GATEWAY";
        ipsec-enabled = "yes";
        ipsec-psk-flags = "0";
        machine-auth-type = "psk";
        machine-certpass-flags = "0";
        mru = "1400";
        mtu = "1400";
        password-flags = "0";
        service-type = "org.freedesktop.NetworkManager.l2tp";
        user = "$L2TP_USER";
        user-auth-type = "password";
      };
      vpn-secrets = {
        password = "$L2TP_PASSWORD";
        ipsec-psk = "$L2TP_IPSEC_PSK";
      };
    };

  networking.networkmanager.ensureProfiles.profiles."Work OpenVPN" =
    lib.recursiveUpdate secrets.sonar.nm_config.work_openvpn {
      connection = {
        id = "work_openvpn";
        type = "vpn";
        autoconnect = false;
      };
      ipv4 = {
        method = "auto";
      };
      ipv6 = {
        method = "auto";
      };
      vpn = {
        remote = "$OPENVPN_REMOTE";
        auth = "none";
        password-flags = "0";
        cert-pass-flags = "0";
        connection-type = "password-tls";
        service-type = "org.freedesktop.NetworkManager.openvpn";
        username = "$OPENVPN_USERNAME";
        ca = config.sops.secrets."networkmanager/vpn/openvpn/ca".path;
        cert = config.sops.secrets."networkmanager/vpn/openvpn/cert".path;
        key = config.sops.secrets."networkmanager/vpn/openvpn/key".path;
        cipher = "$OPENVPN_CIPHER";
        challenge-response-flags = "2";
        dev = "tun";
        mssfix = "1420";
        ping = "15";
        ping-restart = "45";
        reneg-seconds = "3600";
        tunnel-mtu = "1500";
      };
      vpn-secrets = {
        cert-pass = "$OPENVPN_CERT_PASS";
        password = "$OPENVPN_PASSWORD";
      };
    };
}
