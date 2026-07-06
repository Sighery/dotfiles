{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
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

      ../common/secrets-setup.nix
      ../common/secrets-syncthing.nix

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "sonar";
  system.stateVersion = "26.05";

  users.users.sighery.extraGroups = [ "docker" ];
  virtualisation.docker.enableOnBoot = true;

  environment.systemPackages = with pkgs; [
    remmina
  ];
}
