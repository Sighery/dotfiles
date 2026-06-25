{ config, lib, inputs, ... }:

{
  sops.secrets."syncthing/gui_pass" = {
    owner = config.users.users.syncthing.name;
    mode = "0400";
  };
  sops.secrets."syncthing/key" = {
    owner = config.users.users.syncthing.name;
    mode = "0400";
  };
  sops.secrets."syncthing/cert" = {
    owner = config.users.users.syncthing.name;
    mode = "0400";
  };

  systemd.tmpfiles.settings."10-keepass" = {
    "/home/sighery/Keepass".d = {
      user = "sighery";
      group = config.users.groups.syncthing.name;
      mode = "0770";
    };
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;

    key = config.sops.secrets."syncthing/key".path;
    cert = config.sops.secrets."syncthing/cert".path;

    guiAddress = inputs.dotfiles-secrets.tiber.syncthing.gui_address;
    guiPasswordFile = config.sops.secrets."syncthing/gui_pass".path;

    overrideDevices = false;
    overrideFolders = false;

    settings = {
      gui.user = inputs.dotfiles-secrets.tiber.syncthing.gui_user;

      options = {
        urAccepted = -1;

        globalAnnounceEnabled = false;
        localAnnounceEnabled = true;
      };

      devices = lib.filterAttrs (
        name: _: name != config.networking.hostName
      ) inputs.dotfiles-secrets.syncthing.devices;

      folders = inputs.dotfiles-secrets.tiber.syncthing.folders;
    };
  };
}
