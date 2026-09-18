pkgs: {
  audio-notification = pkgs.callPackage ./audio-notification { };
  brightness-notification = pkgs.callPackage ./brightness-notification { };
  ffmpeg-helpers = pkgs.callPackage ./ffmpeg-helpers { };
  hermes = pkgs.callPackage ./hermes { };
  irlserver-irl-srt-server = pkgs.callPackage ./irlserver-irl-srt-server { };
  irlserver-srt = pkgs.callPackage ./irlserver-srt { };
  irlserver-srtla = pkgs.callPackage ./irlserver-srtla { };
  kitty-grab = pkgs.callPackage ./kitty-grab { };
  openirl-srt = pkgs.callPackage ./openirl-srt { };
  openirl-srt-live-server = pkgs.callPackage ./openirl-srt-live-server { };
  openirl-srtla = pkgs.callPackage ./openirl-srtla { };
  scrcpy-rofi = pkgs.callPackage ./scrcpy-rofi { };
  spotify-adblock = pkgs.callPackage ./spotify-adblock { };
  vineflower = pkgs.callPackage ./vineflower { };
  vscode-antislop-settings = pkgs.callPackage ./vscode-antislop-settings { };
  xclipboard = pkgs.callPackage ./xclipboard { };
}
