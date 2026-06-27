{ config, lib, osConfig, inputs, ... }:

let
  hostname = osConfig.networking.hostName;
in
{
  sops.secrets."syncthing/gui_pass" = {
    mode = "0400";
  };
  sops.secrets."syncthing/key" = {
    mode = "0400";
  };
  sops.secrets."syncthing/cert" = {
    mode = "0400";
  };

  services.syncthing = {
    enable = true;

    key = config.sops.secrets."syncthing/key".path;
    cert = config.sops.secrets."syncthing/cert".path;

    guiAddress = inputs.dotfiles-secrets."${hostname}".syncthing.gui_address;
    # syncthing generate --home=path/ --gui-user=user --gui-password=-
    guiCredentials = {
      username = inputs.dotfiles-secrets."${hostname}".syncthing.gui_user;
      passwordFile = config.sops.secrets."syncthing/gui_pass".path;
    };

    overrideDevices = false;
    overrideFolders = false;

    settings = {
      options = {
        urAccepted = -1;
        crashReportingEnabled = false;

        startBrowser = false;

        globalAnnounceEnabled = false;
        localAnnounceEnabled = true;

        listenAddresses =
          inputs.dotfiles-secrets."${hostname}".syncthing.listenAddresses;
      };

      devices = lib.filterAttrs (
        name: _: name != hostname
      ) inputs.dotfiles-secrets.syncthing.devices;

      folders = inputs.dotfiles-secrets."${hostname}".syncthing.folders;
    };
  };

  systemd.user.services.syncthing.Unit.After = [ "sops-nix.service" ];
}
