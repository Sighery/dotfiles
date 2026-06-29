{ config, pkgs, inputs, ... }:

{
  sops.secrets."syncthing-relay/key" = { };
  sops.secrets."syncthing-relay/cert" = { };

  sops.secrets."tokens/wilem" = {
    sopsFile = "${inputs.dotfiles-secrets}/secrets/common/syncthing-relay.yaml";
    restartUnits = [ "syncthing-relay.service" ];
  };

  services.syncthing.relay = {
    enable = true;

    port = inputs.dotfiles-secrets.syncthing.relays.wilem.port;

    enableStatusSrv = false;

    key = config.sops.secrets."syncthing-relay/key".path;
    cert = config.sops.secrets."syncthing-relay/cert".path;
    token = config.sops.secrets."tokens/wilem".path;

    providedBy = "Sighery";

    extraOptions = [
      "--debug"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    inputs.dotfiles-secrets.syncthing.relays.wilem.port
  ];
}
