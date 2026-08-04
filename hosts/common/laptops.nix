{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  services.upower = {
    enable = true;

    usePercentageForPolicy = true;
    percentageLow = 15;
    percentageCritical = 5;
  };
}
