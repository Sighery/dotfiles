{ config
, pkgs
, lib
, osConfig
, inputs
, ...
}:

{
  imports = [
    ./bash.nix
    ./brave.nix
    ./colordiff.nix
    ./dbeaver.nix
    ./direnv.nix
    ./dunst.nix
    ./firefox.nix
    ./git.nix
    ./gpg.nix
    ./i3.nix
    ./kdeconnect.nix
    ./keepass.nix
    ./khal.nix
    ./kitty.nix
    ./laptops.nix
    ./mimeapps.nix
    ./neovim.nix
    ./networkmanager-dmenu.nix
    ./rofi.nix
    ./screen.nix
    ./spotify.nix
    ./ssh.nix
    ./syncthing.nix
    ./vscode.nix
  ];

  home.username = "sighery";
  home.homeDirectory = "/home/sighery";
  home.stateVersion = osConfig.system.stateVersion;

  home.packages = with pkgs; [
    i3-balance-workspace
  ]
  ++ lib.optional config.services.autorandr.enable pkgs.arandr;

  home.file."Pictures/.keep".text = "";
  home.file."Programming/.keep".text = "";
  home.file."Work/.keep".text = "";
}
