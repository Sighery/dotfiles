{ config, ... }:

{
  sops.secrets."syncthing/gui_pass" = {
    owner = config.users.users.sighery.name;
    mode = "0400";
  };
  sops.secrets."syncthing/key" = {
    owner = config.users.users.sighery.name;
    mode = "0400";
  };
  sops.secrets."syncthing/cert" = {
    owner = config.users.users.sighery.name;
    mode = "0400";
  };
}
