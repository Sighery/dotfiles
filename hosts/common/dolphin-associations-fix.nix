{ pkgs, ... }:

{
  # Taken from https://github.com/NixOS/nixpkgs/issues/409986#issuecomment-5147676633
  environment.etc."xdg/menus/applications.menu".source =
    pkgs.runCommand "applications.menu" { } ''
      cp ${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu $out
    '';
}
