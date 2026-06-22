{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      fantasque-sans-mono
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];

    fontconfig.enable = true;
    fontconfig.defaultFonts.monospace = [ "Fantasque Sans Mono" ];
  };
}
