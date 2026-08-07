{ lib, osConfig, ... }:

let
  hostname = osConfig.networking.hostName;
in
{
  programs.autorandr = lib.mkIf (hostname == "sonar") {
    enable = true;
  };
}
