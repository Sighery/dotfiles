{ config, lib, pkgs, ... }:

{
  imports = [
    ../common/i3wm.nix
    ../common/env-packages.nix
    ../common/env-packages-personal.nix
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
    ../common/brave-policies.nix
    ../common/arandr.nix
    ../common/laptops.nix
    ../common/firefox.nix
    ../common/dconf.nix
    ../common/usb-automounting.nix
    ../common/dolphin-associations-fix.nix
    ../common/binary-cache-use.nix

    ../common/wireless.nix
    ../common/main.nix

    ../common/secrets-setup.nix
    ../common/secrets-syncthing.nix

    ../common/binary-cache-sign.nix
    ../common/binary-cache-serve.nix

    ./hardware-configuration.nix
  ];

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 50;
      STOP_CHARGE_THRESH_BAT0 = 75;
    };
  };

  users.users.sighery.packages = with pkgs; [
    discord
    kdePackages.kate
    spotify
  ];

  users.users.sighery.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOxQ9pRCIOB5vbPl2CQiWJscbmX5Ct1hpbJXFJWL9QlA"
  ];

  networking.firewall.enable = false;
}
