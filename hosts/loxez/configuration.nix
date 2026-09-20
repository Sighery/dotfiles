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
    ../common/firefox.nix
    ../common/dconf.nix
    ../common/usb-automounting.nix
    ../common/dolphin-associations-fix.nix
    ../common/kindles-networking.nix
    ../common/ghidra.nix
    ../common/binary-cache-pubkeys.nix
    ../common/binary-cache-substituters.nix

    ../common/main.nix

    ../common/secrets-setup.nix
    ../common/secrets-syncthing.nix

    ../common/binary-cache-sign.nix
    ../common/binary-cache-serve.nix

    ./hardware-configuration.nix
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    pkgsCross.armv7l-hf-multiplatform.glibc
  ];

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "armv7l-linux"
    "armv6l-linux"
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  users.users.sighery.packages = with pkgs; [
    darktable
    discord
    droidcam
    kdePackages.kate
    ns-usbloader
    nsz
    spotify
  ];

  environment.systemPackages = with pkgs; [
    picard
    audacity
    davinci-resolve
    qbittorrent
    android-tools
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", MODE="0666"
  '';

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  users.users.sighery.openssh.authorizedKeys.keys = [
    # Tiber
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJ9YACD3IkFImsFytVAoM1jU9K0xFTMV0WeJdnAxbog"
  ];

  networking.firewall.enable = false;
}
