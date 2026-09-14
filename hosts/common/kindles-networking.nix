{ lib, ... }:

{
  # Kindle USB SSH configuration
  systemd.network.networks."10-kindle-usb-ssh" = {
    matchConfig.MACAddress = lib.strings.concatStringsSep " " [
      # PW5 addresses
      "EE:49:00:00:00:00"
      "12:08:B5:27:B9:47"
      # KCOLOR addresses
      "52:A8:19:E3:86:8E"
      "66:C5:22:15:03:E8"
      "AA:85:83:B7:73:4D"
    ];
    address = [ "192.168.15.201/24" ];
    DHCP = "no";
  };

  networking = {
    hosts = {
      "192.168.0.43" = [ "kpw5" ];
      "192.168.0.44" = [ "kpw5" ];
      "192.168.0.45" = [ "kpw5" ];
      "192.168.0.112" = [ "kscribe" ];
      "192.168.0.113" = [ "kscribe" ];
      "192.168.0.116" = [ "kcolor" ];
      "192.168.0.117" = [ "kcolor" ];
    };
  };
}
