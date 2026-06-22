{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "8.8.8.8"
    ];

    # This was broken with NixOS 26.05
    # https://github.com/NixOS/nixpkgs/issues/507838
    defaultGateway = {
      address = "172.31.1.1";
      interface = "eth0";
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };

    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;

    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "178.105.220.127"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2a01:4f8:c015:ce37::1"; prefixLength = 64; }
          { address = "fe80::9000:7ff:feec:9f8d"; prefixLength = 64; }
        ];
        ipv4.routes = [{ address = "172.31.1.1"; prefixLength = 32; }];
        ipv6.routes = [{ address = "fe80::1"; prefixLength = 128; }];
      };
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="92:00:07:ec:9f:8d", NAME="eth0"
  '';
}
