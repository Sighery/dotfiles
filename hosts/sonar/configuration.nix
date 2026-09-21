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
    ../common/keyboards.nix
    ../common/logitech.nix
    ../common/audio.nix
    ../common/bluetooth.nix
    ../common/docker.nix
    ../common/openssh.nix
    ../common/documentation.nix
    ../common/users.nix
    ../common/i18n.nix
    ../common/brave-policies.nix
    ../common/laptops.nix
    ../common/autorandr.nix
    ../common/firefox.nix
    ../common/dconf.nix
    ../common/usb-automounting.nix
    ../common/dolphin-associations-fix.nix
    ../common/binary-cache-pubkeys.nix
    ../common/binary-cache-substituters.nix

    ../common/secrets-setup.nix

    ../common/wireless-networkmanager.nix
    ../common/main.nix

    ../common/secrets-syncthing.nix

    ./networking.nix

    ./hardware-configuration.nix
  ];

  users.users.sighery.extraGroups = [ "docker" ];
  virtualisation.docker.enableOnBoot = true;

  services.libinput = {
    enable = true;

    touchpad = {
      accelProfile = "flat";
      accelSpeed = "0.55";
    };
  };

  environment.systemPackages = with pkgs; [
    remmina
    dbeaver-bin
  ];

  networking.firewall.enable = false;
}
