{ config, pkgs, secrets, ... }:

let
  relayPort = secrets.syncthing.relays.wilem.port;
in
{
  sops.secrets."syncthing-relay/key" = { };
  sops.secrets."syncthing-relay/cert" = { };

  sops.secrets."tokens/wilem" = {
    sopsFile = "${secrets}/secrets/common/syncthing-relay.yaml";
    restartUnits = [ "syncthing-relay.service" ];
  };

  services.syncthing.relay = {
    enable = true;

    port = relayPort;

    key = config.sops.secrets."syncthing-relay/key".path;
    cert = config.sops.secrets."syncthing-relay/cert".path;
    token = config.sops.secrets."tokens/wilem".path;

    statusListenAddress = null;
    statusPort = null;

    providedBy = "sighery.com";

    extraOptions = [
      "--debug"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    relayPort
  ];
}
