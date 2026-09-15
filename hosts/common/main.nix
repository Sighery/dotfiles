{ config, lib, pkgs, ... }:

{
  networking.useNetworkd = true;
  systemd.network.enable = true;
}
