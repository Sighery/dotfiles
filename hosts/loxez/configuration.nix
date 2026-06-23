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

    ../common/main.nix

    ./syncthing.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  sops.defaultSopsFile = "${inputs.dotfiles-secrets}/secrets/${config.networking.hostName}/main.yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    pkgsCross.armv7l-hf-multiplatform.glibc
  ];

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "armv7l-linux"
    "armv6l-linux"
  ];

  networking.hostName = "loxez"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.xserver.videoDrivers = [ "nvidia" ];

  users.users.sighery.packages = with pkgs; [
    darktable
    droidcam
    ns-usbloader
    nsz
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
