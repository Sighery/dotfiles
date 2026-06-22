{ lib, ... }:

{
  # Enable Flakes and Nix Command
  nix.settings.experimental-features = lib.mkDefault [
    "nix-command"
    "flakes"
  ];
}
