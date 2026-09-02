{ config, secrets, ... }:

let
  hostname = config.networking.hostName;
in
{
  sops.defaultSopsFile = "${secrets}/secrets/${hostname}/main.yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
}
