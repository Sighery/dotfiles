{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.arandr
  ];
}
