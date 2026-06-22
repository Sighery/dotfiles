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
      kdePackages.kate
      spotify
      audio-notification
      xclipboard
    ] ++ lib.optionals
      (
        config.networking.hostName == "loxez"
          || config.networking.hostName == "tiber"
      ) [
      pkgs.discord
    ];
  };
}
