{ pkgs, ... }:

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
    ];
  };
}
