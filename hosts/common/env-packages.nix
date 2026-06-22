{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Flakes requires git
    git
    # For sops-nix
    sops
    age
    ssh-to-age

    tig
    wget
    curl
    nyxt
    moreutils
    less
    eza
    cheese
    scrot
    peek
    yq
    jq
    colordiff
    ripgrep
    kitty
    libreoffice
    ranger
    usbutils
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.kio-extras
    kdePackages.kio-fuse
    jmtpfs
    lxmenu-data
    shared-mime-info
    docker
    docker-compose
    zip
    unzip
    unrar
    rar
    steam-run
    numlockx
    xsecurelock
    xclip
    i3-resurrect
    dunst
    libnotify
    dconf
    gimp-with-plugins
    gimpPlugins.resynthesizer
    tree
    vlc
    keepassxc
    pavucontrol
    ncpamixer
    rofi
    rofi-pass
    jmtpfs
    khal
    calibre
    tauon
    wireshark
    playerctl
    ghidra
    gdb
    minicom
    tio
    scrcpy
    scrcpy-rofi
    ffmpeg-helpers
    gcc
    gnum4
    gnumake
    file
    yt-dlp
    ffmpeg
    qbittorrent
    inetutils
    screen
  ];
}
