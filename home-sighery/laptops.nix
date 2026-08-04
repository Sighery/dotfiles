{ lib, osConfig, ... }:

{
  services.poweralertd = lib.mkIf (osConfig.services.upower.enable == true) {
    enable = true;
    extraArgs = [
      "-s"
    ];
  };
}
