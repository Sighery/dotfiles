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

    ../common/main.nix

    ../common/secrets-setup.nix
    ../common/secrets-syncthing.nix

    # Include the results of the hardware scan.
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

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

  # Allow unfree packages
  nixpkgs.config.permittedInsecurePackages = [
    "segger-jlink-qt4-810"
    "segger-jlink-qt4-874"
  ];
  nixpkgs.config.segger-jlink.acceptLicense = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    picard
    audacity
    nrfconnect
    nrfconnect-bluetooth-low-energy
    davinci-resolve
    qbittorrent
    android-tools
  ];

  #nixpkgs.config.segger-jlink.acceptLicense = true;

  services.udev.packages = [
    pkgs.nrf-udev
    pkgs.segger-jlink
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", MODE="0666"
  '';

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
}
