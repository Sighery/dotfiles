{ secrets, ... }:

let
  eth0 = "enp12s0";
in
{
  networking.interfaces.${eth0}.ipv4.addresses = [
    {
      address = secrets.home_lan.loxez_eth;
      prefixLength = 24;
    }
  ];

  networking.defaultGateway = {
    address = secrets.home_lan.gateway;
    interface = eth0;
  };

  networking.nameservers = [
    secrets.home_lan.gateway
  ];
}
