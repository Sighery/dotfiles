{ pkgs, config, lib, ... }:

{
  users.users.sighery = {
    isNormalUser = true;
    description = "Sighery";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "dialout"
    ];
    packages = with pkgs; [
      audio-notification
      xclipboard
    ] ++ lib.optionals
      (
        config.networking.hostName == "loxez"
          || config.networking.hostName == "tiber"
      ) [
      pkgs.kdePackages.kate
      pkgs.spotify
      pkgs.discord
    ];
  };
}
