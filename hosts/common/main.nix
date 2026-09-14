{ config, lib, pkgs, ... }:

{
  networking.useNetworkd = true;
  systemd.network.enable = true;

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
}
