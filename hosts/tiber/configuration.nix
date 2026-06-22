{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../common/i3wm.nix
    ../common/env-packages.nix
    ../common/env-aliases.nix
    ../common/env-variables.nix
    ../common/nix-experiments.nix
    ../common/fonts.nix
    ../common/neovim.nix
    ../common/logitech.nix
    ../common/audio.nix
    ../common/bluetooth.nix
    ../common/docker.nix
    ../common/openssh.nix
    ../common/documentation.nix
    ../common/users.nix
    ../common/i18n.nix

    ../common/wireless.nix
    ../common/main.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  sops.defaultSopsFile = "${inputs.dotfiles-secrets}/secrets/${config.networking.hostName}/main.yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  networking.hostName = "tiber";

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 50;
      STOP_CHARGE_THRESH_BAT0 = 75;
    };
  };

  users.users.sighery.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOxQ9pRCIOB5vbPl2CQiWJscbmX5Ct1hpbJXFJWL9QlA"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
