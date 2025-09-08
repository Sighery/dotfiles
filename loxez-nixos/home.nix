{ config, pkgs, ... }:

{
  imports = [
    ./home-sighery/i3.nix
    ./home-sighery/vscode.nix
    ./home-sighery/kitty.nix
    ./home-sighery/rofi.nix
    ./home-sighery/dunst.nix
    ./home-sighery/neovim.nix
    ./home-sighery/mimeapps.nix
  ];

  home.username = "sighery";
  home.homeDirectory = "/home/sighery";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  home.file."Pictures/.keep".text = "";

  home.file.".colordiffrc".text = ''
    banner=no
  '';

  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [
    droidcam-obs
    obs-pipewire-audio-capture
  ];

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
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.firefox.enable = true;

  programs.gpg = {
    enable = true;

    settings = {
      keyid-format = "0xlong";
      with-fingerprint = true;
      with-subkey-fingerprints = true;
      with-keygrip = true;
      use-agent = true;
      keyserver = "eu.pool.sks-keyservers.net";
      local-user = "9454A24E1B5E963078B6E9317C02D10683ADCFB8";
    };
  };

  services.gpg-agent = {
    enable = true;

    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
  };

  programs.keychain = {
    enable = true;

    enableBashIntegration = true;
    extraFlags = [
      "--quiet"
      "--noask"
    ];
  };

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

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    includes = [
      {
        condition = "gitdir:~/Programming/";

        contents = {
          user = {
            email = "11218602+Sighery@users.noreply.github.com";
            name = "Sighery";
            signingKey = "9454A24E1B5E963078B6E9317C02D10683ADCFB8";
          };

          commit = {
            gpgSign = "true";
          };

          core = {
            pager = "less -x1,5";
          };

          rerere = {
            enabled = "true";
          };

          status = {
            showUntrackedFiles = "all";
          };

          format = {
            pretty = "fuller";
          };
        };
      }
    ];

  };

  programs.ssh = {
    enable = true;

    addKeysToAgent = "yes";

    matchBlocks = {
      "github.com" = {
        user = "11218602+Sighery@users.noreply.github.com";
        identityFile = "~/.ssh/lexoz_github";
        identitiesOnly = true;
      };
      "gitlab.com" = {
        user = "4689618-Sighery@users.noreply.gitlab.com";
        identityFile = "~/.ssh/id_gitlab";
      };
      "kpw5" = {
        user = "root";
        hostname = "192.168.0.43";
        identityFile = "~/.ssh/kpw5";
        identitiesOnly = true;
      };
      "kscribe" = {
        user = "root";
        hostname = "192.168.0.113";
        identityFile = "~/.ssh/kscribe";
        identitiesOnly = true;
      };
    };
  };

  services.kdeconnect = {
    enable = true;
  };
}
