{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    autorun = true;

    xkb = {
      layout = "us";
      variant = "";
    };

    desktopManager.xterm.enable = false;

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
      updateSessionEnvironment = true;

      extraPackages = with pkgs; [
        rofi
        i3status
        numlockx
      ];
    };

    displayManager.lightdm = {
      enable = true;

      background = "#000000";

      extraSeatDefaults = ''
        greeter-hide-users=true
        greeter-show-manual-login=true
        allow-guest=false
        greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
      '';
    };
  };

  services.displayManager.defaultSession = "none+i3";
}
