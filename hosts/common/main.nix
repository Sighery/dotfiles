{ config, lib, pkgs, ... }:

{
  imports = [ ];

  #programs.nix-ld.enable = true;
  #programs.nix-ld.libraries = with pkgs; [
  #  pkgsCross.armv7l-hf-multiplatform.glibc
  #];

  #boot.binfmt.emulatedSystems = [
  #  "aarch64-linux"
  #  "armv7l-linux"
  #  "armv6l-linux"
  #];

  #networking.hostName = "loxez"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.useNetworkd = true;
  systemd.network.enable = true;
  #systemd.network.networks."00-default" = {
  #  matchConfig.Name = "*";
  #  DHCP = "yes";
  #};

  # Kindle USB SSH configuration
  systemd.network.networks."10-kindle-usb-ssh" = {
    #matchConfig.MACAddress = "ee:49:00:00:00:00";
    #matchConfig.Name = "enp11s0u2u1";
    #matchConfig.AlternativeNames = [ "enxee4900000000" ];
    #matchConfig.Name = "enxee4900000000";
    # KPW5 +
    #matchConfig.MACAddress = "12:08:b5:27:b9:47";
    matchConfig.MACAddress = lib.strings.concatStringsSep " " [
      # PW5 addresses
      "EE:49:00:00:00:00"
      "12:08:B5:27:B9:47"
      # KCOLOR addresses
      "52:A8:19:E3:86:8E"
      "66:C5:22:15:03:E8"
      "AA:85:83:B7:73:4D"
    ];
    address = [ "192.168.15.201/24" ];
    DHCP = "no";
    #linkLocalAddressing = "ipv4";
  };

  networking = {
    #interfaces.enp11s0u2u1 = {
    #  ipv4.addresses = [{
    #    address = "192.168.15.201";
    #    prefixLength = 24;
    #  }];
    #};

    hosts = {
      #"192.168.15.244" = [ "kpw5" "kscribe" "kcolor" ];
      "192.168.0.43" = [ "kpw5" ];
      "192.168.0.44" = [ "kpw5" ];
      "192.168.0.45" = [ "kpw5" ];
      "192.168.0.112" = [ "kscribe" ];
      "192.168.0.113" = [ "kscribe" ];
      "192.168.0.116" = [ "kcolor" ];
      "192.168.0.117" = [ "kcolor" ];
    };
    #extraHosts = ''
    #  192.168.15.244 kpw5
    #  192.168.15.244 kscribe
    #  192.168.15.244 kcolor
    #'';
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  #networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  services.picom.enable = true;

  # Install firefox.
  programs.firefox.enable = true;
  #programs.adb.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowUnfreePredicate =
  #  pkg:
  #  builtins.elem (lib.getName pkg) [
  #    "spotify"
  #    "spotify-unwrapped"
  #    "nvidia-x11"
  #    "nvidia-settings"
  #    "slack"
  #    "vscode-extension-ms-vsliveshare-vsliveshare"
  #    "discord"
  #  ];
  #nixpkgs.config.permittedInsecurePackages = [
  #  "segger-jlink-qt4-810"
  #  "segger-jlink-qt4-874"
  #];
  #nixpkgs.config.segger-jlink.acceptLicense = true;


  # Fix for Dolphin lacking file associations
  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  # Brave managed configuration
  environment.etc."/brave/policies/managed/GroupPolicy.json".text = builtins.toJSON {
    BraveRewardsDisabled = 1;
    BraveWalletDisabled = 1;
    BraveAIChatEnabled = 0;
    BraveNewsDisabled = 1;
    BraveP3AEnabled = "Disabled";
    BraveStatsPingEnabled = 0;
    BraveWebDiscoveryEnabled = 0;
    AIModeSettings = 1;
    GenAILocalFoundationalModelSettings = 0;
    AutofillPredictionSettings = 2;
    CreateThemesSettings = 2;
    DevToolsGenAiSettings = 1;
    FindsSettings = 2;
    GeminiActOnWebSettings = 1;
    GeminiSettings = 1;
    GenAIInlineImageSettings = 2;
    GenAIPhotoEditingSettings = 2;
    GenAISmartGroupingSettings = 2;
    GenAIVcBackgroundSettings = 2;
    GenAiChromeOsSmartActionsSettings = 2;
    GenAiDefaultSettings = 2;
    AutofillCreditCardEnabled = false;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
    pinentryPackage = pkgs.pinentry-curses;
    #settings = {
    #  no-grab = "";
    #};
  };
  programs.ssh.startAgent = true;

  programs.dconf.enable = true;

  programs.ghidra = {
    enable = true;
    gdb = true;
  };

  # List services that you want to enable:
  # USB Automounting
  services.gvfs.enable = false;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  services.udev.packages = [
    #pkgs.nrf-udev
    #pkgs.segger-jlink
  ];

  #services.udev.extraRules = ''
  #  SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", MODE="0666"
  #'';

  #services.plex = {
  #  enable = true;
  #  openFirewall = true;
  #};

  #services.clamav = {
  #  daemon.enable = true;
  #  scanner.enable = true;
  #};

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
  #system.stateVersion = "25.05"; # Did you read the comment?
}
