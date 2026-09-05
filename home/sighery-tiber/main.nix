{ pkgs, ... }:

{
  imports = [
    ../sighery-common/main.nix
  ];

  programs.vscodium.profiles.default.userSettings = {
    "window.zoomLevel" = 1;
  };
}
