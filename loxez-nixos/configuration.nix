# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

#let
#  fantasque-sans-mono = pkgs.callPackage fonts/fantasque-sans-mono {};
#in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Enable Flakes and Nix Command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "loxez"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;

    videoDrivers = [ "nvidia" ];

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };

    desktopManager.xterm.enable = false;

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      updateSessionEnvironment = true;

      extraPackages = with pkgs; [
        rofi
	i3status
      ];
    };

    displayManager.lightdm = {
      enable = true;

      background = "#000000";

      extraSeatDefaults = ''
        greeter-hide-users=true
	greeter-show-manual-login=true
	allow-guest=false
	greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
      '';
    };
  };

  services.displayManager.defaultSession = "none+i3";

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  services.picom.enable = true;

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;

    # Enable connecting with A2DP profile
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  users.users.sighery = {
    isNormalUser = true;
    description = "Sighery";
    extraGroups = [
      "networkmanager" "wheel" "docker" "adbusers"
      "dialout"
    ];
    packages = with pkgs; [
      kdePackages.kate
      spotify
      discord
      arduino-ide arduino-cli
      droidcam
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.adb.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify" "spotify-unwrapped"
    "nvidia-x11" "nvidia-settings"
    "slack"
    "vscode-extension-ms-vsliveshare-vsliveshare"
    "discord"
  ];

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
    info.enable = true;
    doc.enable = true;
  };

  environment.shellAliases = {
    ls = "eza -F";
    exa = "eza -F";
    grep = "grep --colour=auto";
    egrep = "egrep --colour=auto";
    fgrep = "fgrep --colour=auto";
    cp = "cp -i";
    less = "less -x4 -R";
    more = "less -x4 -R";
    ll = "eza --long --git --header --links --group --classify";
    exal = "eza --long --git --header --links --group --classify";
    la = "eza --all --classify";
    exaa = "eza --all --classify";
    exala = "eza --all --long --git --header --links --group --classify";
    kitten = "kitty +kitten";
    diff = "colordiff -u";
    colordiff = "colordiff -u";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Flakes requires git
    git tig
    wget curl
    brave firefox nyxt
    moreutils less eza
    gnome.cheese scrot peek
    yq jq colordiff
    kitty
    libreoffice
    gnome.gnome-keyring gnome.seahorse
    ranger pcmanfm lxmenu-data shared-mime-info
    docker docker-compose
    zip unzip
    numlockx xsecurelock xclip
    i3 i3-resurrect dunst libnotify
    dconf
    gimp
    vlc
    home-manager
    keepassxc
    pavucontrol ncpamixer
    rofi rofi-pass
    jmtpfs
    khal
    foliate calibre
  ];

  environment.variables = {
    BROWSER = "brave";
    TERMINAL = "kitty";
    TERMCDM = "kitty";
    PAGER = "less";

    XSECURELOCK_PASSWORD_PROMPT = "time";
    XSECURELOCK_SHOW_HOSTNAME = "0";
    XSECURELOCK_SHOW_USERNAME = "0";
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

  programs.neovim = {
    enable = true;
    withPython3 = true;
    withNodeJs = true;
    vimAlias = true;
    defaultEditor = true;

    configure = {
      customRC = ''
        set number relativenumber
      '';
    };
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = [
      pkgs.fantasque-sans-mono
    ];

    fontconfig.enable = true;
    fontconfig.defaultFonts.monospace = [
      "Fantasque Sans Mono"
    ];
  };

  # List services that you want to enable:
  # USB Automounting
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
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
  system.stateVersion = "24.05"; # Did you read the comment?

}
