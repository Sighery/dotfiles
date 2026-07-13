{ config
, pkgs
, lib
, osConfig
, inputs
, ...
}:

{
  imports = [
    ./i3.nix
    ./vscode.nix
    ./kitty.nix
    ./rofi.nix
    ./dunst.nix
    ./neovim.nix
    ./mimeapps.nix
    ./brave.nix
    ./keepass.nix
    ./gpg.nix
    ./ssh.nix
    ./git.nix
    ./syncthing.nix
    ./networkmanager-dmenu.nix
  ];

  home.username = "sighery";
  home.homeDirectory = "/home/sighery";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    i3-balance-workspace
  ];

  home.file."Pictures/.keep".text = "";
  home.file."Programming/.keep".text = "";
  home.file."Work/.keep".text = "";

  home.file.".colordiffrc".text = ''
    banner=no
  '';

  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [
    droidcam-obs
    obs-pipewire-audio-capture
  ];

  programs.screen = {
    enable = true;
    screenrc = ''
      startup_message off
    '';
  };

  programs.bash = {
    enable = true;

    initExtra = ''
            _kitten_completions() {
                local src
                local limit
                # We need some slight changes so that we can use kitty's native
                # autocompletion. Kitty won't understand our "kitten" command, but
                # if we turn "kitten" into "kitty +kitten" it will be able to
                # autocomplete just fine
                local unaliased
                unaliased=("kitty" "+kitten" "''${COMP_WORDS[@]:1}")
                # Send all words up to the word the cursor is currently on
                let limit=1+$COMP_CWORD+1
                src=$(printf "%s
            " "''${unaliased[@]:0:$limit}" | kitty +complete bash)
                if [[ $? == 0 ]]; then
                    eval ''${src}
                fi
            }

            complete -o nospace -F _kitten_completions kitten

            tabs -4

      	  davinci_convert() {
                infile="$1"
      		  outfile="''${infile%.*}.mov"
      		  ffmpeg -i "$infile" -c:v dnxhd -profile:v 3 -pix_fmt yuv422p -c:a pcm_s16le "$outfile"
      	  }
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.firefox.enable = true;
  programs.firefox.configPath = "${config.xdg.configHome}/mozilla/firefox";

  xdg.configFile."khal/config".text = ''
    [locale]
    timeformat = %H:%M
    dateformat = %Y-%m-%d
    longdateformat = %Y-%m-%d
    datetimeformat = %Y-%m-%d %H:%M
    longdatetimeformat = %Y-%m-%d %H:%M

    [calendars]
      [[home]]
        path = ${config.home.homeDirectory}/.calendars/home/
  '';

  services.kdeconnect = {
    enable = true;
  };
}
