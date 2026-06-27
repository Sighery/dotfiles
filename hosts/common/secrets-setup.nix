{ config, inputs, ... }:

{
  sops.defaultSopsFile = "${inputs.dotfiles-secrets}/secrets/${config.networking.hostName}/main.yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
}
