{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam-run
    vlc
    calibre
    tauon
    wireshark
    ghidra
    minicom
    tio
    scrcpy
    scrcpy-rofi
    ffmpeg-helpers
    gcc
    gnum4
    gnumake
    yt-dlp
    ffmpeg
    qbittorrent
  ];
}
