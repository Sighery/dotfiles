# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let unstable = import
  (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
  { config = config.nixpkgs.config; };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
  #packageOverrides = pkgs: rec {
  #  fantasque-sans-mono = pkgs.fantasque-sans-mono.override {
  #    common.version = "1.7.2";
  #  };
  #};

  boot.supportedFilesystems = [ "ntfs" ];

  boot.loader = {
    systemd-boot.enable = false;

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    grub = {
      enable = true;
      version = 2;
      
      devices = [ "nodev" ];
      default = 1;
      efiSupport = true;
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root 74A0-69FC
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #let
  #  pkgs = import (builtins.fetchGit {
  #    name = "fantasque-sans-mono-v1.7.2";
  #    url = "https://github.com/NixOS/nixpkgs/";
  #    ref = "refs/heads/nixos-20.03";
  #    rev = "b5b7bd6ebba2a165e33726b570d7ab35177cf951";
  #  }) {};
  #in {
  #  fonts.fonts = with pkgs; [
  #    pkgs.fantasque-sans-mono;
  #  ];
  #}
  #
  #nixpkgs.config.packageOverrides = pkgs: rec {
  #  fantasque-sans-mono = pkgs.fantasque-sans-mono.overrideAttrs (oldAttrs: rec {
  #    version = "1.7.2";
  #  });
  #};
  #pkgs.fantasque-sans-mono.overrideAttrs
  #
  # nixpkgs.overlays = [ (self: super: {
  #   fantasque-sans-mono = super.fantasque-sans-mono.overrideAttrs (old: {
  #     version = "1.7.2";
  #   });
  # }) ];

  nixpkgs.config.packageOverrides = pkgs: rec {
    fantasque-sans-mono = pkgs.callPackage fonts/fantasque-sans-mono {};
  };

  fonts = {
    enableDefaultFonts = true;

    fonts = with pkgs; [
      fantasque-sans-mono
    ];

    fontconfig = {
      localConf = ''
        <match target='font'>
          <test name='fontformat' compare='not_eq'>
            <string/>
          </test>
          <test name='family'>
            <string>Fantasque Sans Mono</string>
          </test>
          <edit name='fontfeatures' mode='assign_replace'>
            <string>ss01</string>
          </edit>
        </match>
      '';
    };

    fontconfig = {
      defaultFonts = {
        monospace = [ "FantasqueSansMono" ];
      };
    };
  };

  

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "FantasqueSansMono";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;

    videoDrivers = [ "nvidia" ];

    screenSection = ''
      Option "metamodes" "DP-4: 5120x1440_120 +0+0; DP-4: nvidia-auto-select +0+0"
    '';

    xrandrHeads = [
      {
        output = "DP-4";
        primary = true;
        monitorConfig = ''
          ModeLine "5120x1440_120.00"  1322.75  5120 5560 6128 7136  1440 1443 1453 1545 -hsync +vsync
          VertRefresh 120
          Option "PreferredMode" "5120x1440"
        '';
      }
      {
        output = "HDMI-1";
        monitorConfig = ''
          Option "Enable" "false"
        '';
      }
    ];

    layout = "us";

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";

      lightdm = {
        enable = true;

        extraSeatDefaults = ''
          greeter-hide-users=true
          greeter-show-manual-login=true
          allow-guest=false
          greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
        '';
      };
    };

    windowManager.i3 = {
      enable = true;

      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };
  };

  # Configure keymap in X11
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Logitech Unifying Receiver
  hardware.logitech = {
    wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sighery = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable 'sudo' for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim
    gnome3.gnome-disk-utility
    ddrescue
    smartmontools
    brave firefox unstable.nyxt
    kitty
    numlockx
    gparted parted
    keepassxc
    git
    zip
    jmtpfs
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

