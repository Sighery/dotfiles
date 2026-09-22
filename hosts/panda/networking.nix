{ secrets, ... }:

let
  wlp = "wlan0";
in
{
  networking.dhcpcd.extraConfig = ''
    interface ${wlp}
      static ip_address=${secrets.home_lan.panda_wlp}/24
      static routers=${secrets.home_lan.gateway}
      static domain_name_servers=${secrets.home_lan.gateway}
  '';
}
