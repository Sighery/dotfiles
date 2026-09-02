{ pkgs, ... }:

{
  imports = [
    ../sighery-common/main.nix
  ];

  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
      obs-pipewire-audio-capture
    ];
  };
}
