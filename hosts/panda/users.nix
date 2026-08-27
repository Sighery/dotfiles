{ pkgs, config, ... }:

{
  users.mutableUsers = true;

  # To hash passwords: mkpasswd -m sha-512
  sops.secrets."users/panda".neededForUsers = true;

  users.users.panda = {
    enable = true;
    isNormalUser = true;
    createHome = true;

    hashedPasswordFile = config.sops.secrets."users/panda".path;

    extraGroups = [
      "wheel"
    ];

    openssh.authorizedKeys.keys = [
      # Loxez
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEsQHJ6gYjFZXKyeyRtCNNHbBHheAeTjD0SAGZmXMUyg"
    ];
  };
}
