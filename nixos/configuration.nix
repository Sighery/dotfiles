# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

#let unstable = import
#  (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
#  { config = config.nixpkgs.config; };
#in
let
  #unstable = import <nixos-unstable> {};
  unstable = import <nixos-unstable> {
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vscode-extension-ms-vsliveshare-vsliveshare"
    ];
  };
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
    ref = "release-21.11";
    rev = "6ce1d64073f48b9bc9425218803b1b607454c1e7";
  };
#let home-manager = builtins.fetchGit {
#  url = "https://github.com/nix-community/home-manager.git";
#  ref = "master";
#  rev = "82c92a18baaa5bd2546b02f006fb0d5dbf4fcfa4";
#};
#vscodium-with-extensions = pkgs.vscode-with-extensions.override {
#  vscode = pkgs.vscodium;
#  vscodeExtensions = (with pkgs.vscode-extensions; [
#    bungcip.better-toml
#    dbaeumer.vscode-eslint
#    eamodio.gitlens
#    Equinusocio.vsc-material-theme
#    equinusocio.vsc-material-theme-icons
#    golang.Go
#    hashicorp.terraform
#    matklad.rust-analyzer
#    ms-azuretools.vscode-docker
#    ms-python.python
#    ms-vscode.atom-keybindings
#    redhat.vscode-yaml
#    rust-lang.rust
#    serayuzgur.crates
#    stkb.rewrap
#    vadimcn.vscode-lldb
#  ]);
#};
i3-volume = pkgs.callPackage pkgs/i3-volume {};
kitty-grab = pkgs.callPackage pkgs/kitty-grab {};
fantasque-sans-mono = pkgs.callPackage fonts/fantasque-sans-mono {};
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify" "spotify-unwrapped"
    "nvidia-x11" "nvidia-settings"
    "slack"
    "vscode-extension-ms-vsliveshare-vsliveshare"
    "plexmediaserver"
  ];
  #nixpkgs.config.allowUnfree = true;
  #packageOverrides = pkgs: rec {
  #  fantasque-sans-mono = pkgs.fantasque-sans-mono.override {
  #    common.version = "1.7.2";
  #  };
  #};

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  home-manager.users.sighery = { config, ... }: {
    home.file."Pictures/.keep".text = "";

    home.file.".colordiffrc".text = ''
      banner=no
    '';

    home.packages = [
      pkgs.slack
      #pkgs.brightnessctl
      #pkgs.ddcutil pkgs.ddcui
    ];

    #services.gnome-keyring.enable = true;
    #services.gnome-keyring.components = [ "pkcs11" "secrets" ];

    #xdg.desktopEntries = {
    #  ranger = {
    #    type = "Application";
    #    name = "ranger";
    #    genericName = "File Manager";
    #    comment = "Launches the ranger file manager";
    #    icon = "utilities-terminal";
    #    terminal = true;
    #    exec = "ranger";
    #    categories = [ "ConsoleOnly" "System" "FileTools" "FileManager" ];
    #    mimeType = [ "inode/directory" ];
    #  };

    #  ikhal = {
    #    type = "Application";
    #    name = "ikhal";
    #    genericName = "Calendar";
    #    comment = "Launches interactive Khal";
    #    icon = "utilities-terminal";
    #    terminal = true;
    #    exec = "ikhal";
    #    categories = [ "ConsoleOnly" "Calendar" ];
    #  };
    #};

    programs.firefox = {
      enable = true;
    };

    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "x-scheme-handler/http" = [ "brave.desktop" ];
        "x-scheme-handler/https" = [ "brave.desktop" ];
        "x-scheme-handler/ftp" = [ "brave.desktop" ];
        "x-scheme-handler/chrome" = [ "brave.desktop" ];
        "text/html" = [ "brave.desktop" ];
        "application/x-extension-htm" = [ "brave.desktop" ];
        "application/x-extension-html" = [ "brave.desktop" ];
        "application/x-extension-shtml" = [ "brave.desktop" ];
        "application/xhtml+xml" = [ "brave.desktop" ];
        "application/x-extension-xhtml" = [ "brave.desktop" ];
        "application/x-extension-xht" = [ "brave.desktop" ];
        "image/jpeg" = [ "viewnior.desktop" "gpicview.desktop" ];
        "image/png" = [ "viewnior.desktop" "gpicview.desktop" ];
        "text/plain" = [ "mousepad.desktop" ];
        "x-scheme-handler/mailto" = [ "userapp-Thunderbird.desktop" ];
        "message/rfc822" = [ "userapp-Thunderbird.desktop" ];
        "application/pdf" = [ "epdfview.desktop" ];
        "application/x-bittorrent" = [ "deluge.desktop" ];
        "x-scheme-handler/about" = [ "brave.desktop" ];
        "x-scheme-handler/unknown" = [ "brave.desktop" ];
      };

      associations.added = {
        "x-scheme-handler/http" = [ "brave.desktop" ];
        "x-scheme-handler/https" = [ "brave.desktop" ];
        "x-scheme-handler/ftp" = [ "brave.desktop" ];
        "x-scheme-handler/chrome" = [ "brave.desktop" ];
        "text/html" = [ "brave.desktop" ];
        "application/x-extension-htm" = [ "brave.desktop" ];
        "application/x-extension-html" = [ "brave.desktop" ];
        "application/x-extension-shtml" = [ "brave.desktop" ];
        "application/xhtml+xml" = [ "brave.desktop" ];
        "application/x-extension-xhtml" = [ "brave.desktop" ];
        "application/x-extension-xht" = [ "brave.desktop" ];
        "image/jpeg" = [ "viewnior.desktop" "gpicview.desktop" ];
        "image/png" = [ "viewnior.desktop" "gpicview.desktop" ];
        "text/plain" = [ "mousepad.desktop" ];
        "x-scheme-handler/mailto" = [ "userapp-Thunderbird.desktop" ];
        "message/rfc822" = [ "userapp-Thunderbird.desktop" ];
        "application/pdf" = [ "epdfview.desktop" ];
        "application/x-bittorrent" = [ "deluge.desktop" ];
      };
    };

    programs.vscode = {
      enable = true;
      package = unstable.vscodium;

      extensions = (with unstable.vscode-extensions; [
        #bbenoist.Nix
        bbenoist.nix
        dbaeumer.vscode-eslint
        eamodio.gitlens
        #golang.Go
        golang.go
        hashicorp.terraform
        matklad.rust-analyzer
        ms-azuretools.vscode-docker
        ms-python.python
        ms-vsliveshare.vsliveshare
        #redhat.vscode-yaml
        serayuzgur.crates
        vadimcn.vscode-lldb
      ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "better-toml";
          publisher = "bungcip";
          version = "0.3.2";
          sha256 = "83e2df8230274ae4a3fe74a694f741d2ddbd92a4e67a0641e41d5c6333fc9022";
        }
        {
          name = "vsc-material-theme";
          publisher = "Equinusocio";
          version = "33.2.2";
          sha256 = "a9a168faf45988c75ffa1c04ca4cf33007f3665fd1a9b7c3848e34549c9ea528";
        }
        {
          name = "vsc-material-theme-icons";
          publisher = "Equinusocio";
          version = "2.2.1";
          sha256 = "81c0259afb4da5f98ce5d86e6db73c74d02fc9f0c212c4a6ffcefdc450ddbd0e";
        }
        {
          name = "atom-keybindings";
          publisher = "ms-vscode";
          version = "3.0.9";
          sha256 = "41ecbbe48ae96f763e5276dffa9a534d5a14dd71805490fca173795ca2615812";
        }
        {
          name = "rust";
          publisher = "rust-lang";
          version = "0.7.8";
          sha256 = "637dda81234c5666950907587799b3c2388ae494d94edcd39264864d0ad2360d";
        }
        {
          name = "rewrap";
          publisher = "stkb";
          version = "1.15.4";
          sha256 = "1s55a78b61ly2fgg7mpnq09g0ard4hriqn6pplkwl6p1bc5g5rfa";
        }
        {
          name = "vscode-yaml";
          publisher = "redhat";
          version = "1.2.2";
          sha256 = "0s68a6h9ri6bwinrd94ppxpcmklvp77gxvrjxkhg3gr5q7377hiy";
        }
        #{
        #  name = "black-formatter";
        #  publisher = "ms-python";
        #  version = "2022.1.11111003";
        #  sha256 = "06n8vz5fr7k8bn5z3p4ganh59c0vzv83ar007szygl7gi9jbx9iq";
        #}
        #{
        #  name = "vscode-pylance";
        #  publisher = "ms-python";
        #  version = "2021.12.2";
        #  sha256 = "1fpk2qv0b5cpcqqhpncqdwjnhhdf42zwj90nkfggc56d8sjvxfzd";
        #}
      ];

      keybindings = [
        {
          key = "ctrl+shift+l";
          command = "workbench.action.editor.changeLanguageMode";
          when = "textInputFocus";
        }
        {
          key = "ctrl+k m";
          command = "-workbench.action.editor.changeLanguageMode";
          when = "textInputFocus";
        }
        {
          key = "ctrl+m";
          command = "-editor.action.toggleTabFocusMode";
        }
        {
          key = "ctrl+alt+-";
          command = "-workbench.action.navigateBack";
        }
        {
          key = "alt+left";
          command = "workbench.action.navigateBack";
        }
        {
          key = "ctrl+shift+-";
          command = "-workbench.action.navigateForward";
        }
        {
          key = "alt+right";
          command = "workbench.action.navigateForward";
        }
        {
          key = "ctrl+alt+-";
          command = "-workbench.action.quickInputBack";
          when = "inQuickOpen";
        }
        {
          key = "alt+left";
          command = "workbench.action.quickInputBack";
          when = "inQuickOpen";
        }
      ];

      userSettings = {
        "update.mode" = "manual";
        "python.experiments.enabled" = false;
        "liveshare.diagnosticMode" = true;
        "liveshare.diagnosticLogging" = true;
        "atomKeymap.promptV3Features" = true;
        "editor.multiCursorModifier" = "ctrlCmd";
        "editor.guides.bracketPairs" = "active";
        "editor.formatOnPaste" = true;
        "editor.minimap.enabled" = false;
        "telemetry.enableCrashReporter" = false;
        "telemetry.enableTelemetry" = false;
        "files.autoSave" = "afterDelay";
        "editor.fontFamily" = "'monospace', monospace, 'Droid Sans Mono', 'Droid Sans Fallback'";
        "editor.insertSpaces" = false;
        "window.menuBarVisibility" = "hidden";
        "window.enableMenuBarMnemonics" = false;
        "workbench.activityBar.visible" = false;
        "workbench.sideBar.location" = "right";
        "workbench.editor.enablePreviewFromQuickOpen" = false;
        "workbench.startupEditor" = "none";
        "editor.renderWhitespace" = "boundary";
        "files.insertFinalNewline" = true;
        "workbench.colorTheme" = "Material Theme Palenight High Contrast";
        "editor.tokenColorCustomizations" = {
          "[Material Theme Palenight High Contrast]" = {
            "textMateRules" = [
              {
                "scope" = [
                  "keyword.control.flow.block-scalar.literal.yaml"
                  "keyword.control.flow.block-scalar.folded.yaml"
                ];
                "settings" = {
                  "fontStyle" = "";
                };
              }
            ];
          };
        };
        "files.trimFinalNewlines" = true;
        "files.trimTrailingWhitespace" = true;
        #"python.experiments.optOutFrom" = [ "pythonJediLSP" "pythonJediLSPcf" ];
        #"python.experiments.optInto" = [ "" ];
        "python.formatting.provider" = "black";
        "python.sortImports.args" = [ "--profile" "black" ];
        "source.organizeImports" = true;
        "python.linting.enabled" = true;
        "python.linting.pylintEnabled" = true;
        "python.linting.mypyEnabled" = true;
        "python.dataScience.askForKernelRestart" = true;
        "editor.formatOnSave" = true;
        "rewrap.autoWrap.enable" = true;
        "rust.clippy_preferences" = "on";
        "gitlens.codeLens.enabled" = false;
        "gitlens.advanced.telemetry.enabled" = false;
        "gitlens.codeLens.authors.enabled" = false;
        "gitlens.showWelcomeOnInstall" = false;
        "gitlens.showWhatsNewAfterUpgrades" = false;
        "explorer.confirmDelete" = false;
        "go.useLanguageServer" = true;
        "explorer.confirmDragAndDrop" = false;
        "redhat.telemetry.enabled" = false;
        "yaml.schemaStore.enable" = true;
        "crates.upToDateDecorator" = "";
        "rust-analyzer.inlayHints.typeHints" = false;
        "rust-analyzer.inlayHints.parameterHints" = false;
        "files.exclude" = {
          "**/.git" = false;
        };
        "files.associations" = {
          "docker-compose.yml" = "yaml";
          "docker-compose.yaml" = "yaml";
          "*.auto.tfvars" = "terraform";
          "*.tfvars" = "terraform";
        };
        "workbench.colorCustomizations" = {
          "editorRuler.foreground" = "#FF4081";
        };
        "editor.rulers" = [
          {
            "column" = 78;
            "color" = "#FF4081";
          }
          {
            "column" = 70;
            "color" = "#FFA700";
          }
        ];
        "terraform.languageServer" = {
          #"enabled" = true;
          #"args" = [];
          "external" = true;
          "args" = [
            "serve"
          ];
        };
        "terraform-ls.experimentalFeatures" = {
          "validateOnSave" = true;
        };
        "[markdown]" = {
          "editor.quickSuggestions" = false;
          "files.trimTrailingWhitespace" = false;
        };
        "[terraform]" = {
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.defaultFormatter" = "hashicorp.terraform";
          "editor.formatOnSave" = false;
        };
        "[yaml]" = {
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
        };
        "black-formatter.path" = [ "venv/bin/black" ];
        "[python]" = {
          "editor.defaultFormatter" = "ms-python.black-formatter";
          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = false;
          "editor.codeActionsOnSave" = {
            "source.organizeImports" = true;
          };
          "editor.rulers" = [
            {
              "column" = 87;
              "color" = "#FF4081";
            }
            {
              "column" = 71;
              "color" = "#5F6368";
            }
            {
              "column" = 79;
              "color" = "#FFA700";
            }
          ];
        };
        "[rust]" = {
          "editor.defaultFormatter" = "rust-lang.rust";
          "editor.rulers" = [
            {
              "column" = 98;
              "color" = "#FF4081";
            }
            {
              "column" = 79;
              "color" = "#5F6368";
            }
            {
              "column" = 89;
              "color" = "#FFA700";
            }
          ];
        };
        "[javascript]" = {
          "editor.rulers" = [
            {
              "column" = 98;
              "color" = "#FF4081";
            }
            {
              "column" = 71;
              "color" = "#5F6368";
            }
            {
              "column" = 79;
              "color" = "#FFA700";
            }
          ];
        };
      };
    };

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

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
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
      '';
    };

    services.dunst = {
      enable = true;

      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
        size = "16x16";
      };

      settings = {
        global = {
          #icon_path = "${pkgs.gnome.adwaita-icon-theme}/share/icons/Adwaita/16x16/status/:${pkgs.gnome.adwaita-icon-theme}/share/icons/Adwaita/16x16/devices/";
          #icon_path = lib.concatStringsSep ":" [
          #  "${pkgs.gnome.adwaita-icon-theme}/share/icons/Adwaita/16x16/status/"
          #  "${pkgs.gnome.adwaita-icon-theme}/share/icons/Adwaita/16x16/devices/"
          #];
          frame_width = 1;
          frame_color = "#788388";
          font = "Fantasque Sans Mono 11";
          markup = "yes";
          sort = "yes";
          indicate_hidden = "yes";
          alignment = "left";
          bounce_freq = 5;
          show_age_threshold = 20;
          word_wrap = "no";
          ignore_newline = "no";
          geometry = "0x4-25+25";
          shrink = "yes";
          transparency = 15;
          idle_threshold = 120;
          monitor = 0;
          follow = "mouse";
          sticky_history = "yes";
          history_length = 5;
          show_indicators = "yes";
          line_height = 0;
          separator_height = 1;
          padding = 8;
          horizontal_padding = 10;
          browser = "${pkgs.xdg-utils}/bin/xdg-open";
          icon_position = "left";
          max_icon_size = 128;
        };

        shortcuts = {
          close = "mod1+space";
          close_all = "ctrl+mod1+space";
          history = "ctrl+mod4+h";
          context = "ctrl+mod1+c";
        };

        urgency_low = {
          background = "#263238";
          foreground = "#556064";
          timeout = 10;
        };

        urgency_normal = {
          background = "#263238";
          foreground = "#F9FAF9";
          timeout = 10;
        };

        urgency_critical = {
          background = "#D62929";
          foreground = "#F9FAF9";
          timeout = 10;
        };
      };
    };

    programs.vim = {
      enable = true;

      settings = {
        tabstop = 4;
        mouse = "a";
        number = true;
      };

      extraConfig = ''
        set colorcolumn=71,79
        set laststatus=2
        filetype indent plugin on
        syntax on
        au FileType gitcommit setlocal tw=70
      '';
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

    xdg.configFile."kitty/diff.conf".text = ''
      syntax_aliases pyj:py pyi:pi recipe:py
      num_context_lines 3
      diff_cmd auto
      pygments_style native

      foreground #D8D6D0
      background #24292E
      title_fg #D8D6D0
      title_bg #181A1B
      margin_fg #CBC7BF
      margin_bg #181A1B
      removed_bg #3D0007
      highlight_removed_bg #5B030D
      removed_margin_bg #480008
      added_bg #004212
      highlight_added_bg #0E5720
      added_margin_bg #005112
      hunk_bg #1C1E1F
      hunk_margin_bg #2A2C2E
      filler_bg #24292E
      margin_filler_bg none
      search_bg #444
      search_fg white
      select_bg #B4D5FE
      select_fg black

      map q         quit
      map j         scroll_by 1
      map k         scroll_by -1
      map home      scroll_to start
      map end       scroll_to end
      map page_down scroll_to next-page
      map page_up   scroll_to prev-page
      map n         scroll_to next-change
      map p         scroll_to prev-change
      map a         change_context all
      map =         change_context default
      map +         change_context 5
      map -         change_context -5
      map /         start_search regex forward
      map ?         start_search regex backward
      map .         scroll_to next-match
      map ,         scroll_to prev-match
      map f         start_search substring forward
      map b         start_search substring backward
    '';

    # kitty-grab kitten
    xdg.configFile."kitty/kitty_grab/grab.py".source = "${kitty-grab}/bin/grab.py";
    xdg.configFile."kitty/kitty_grab/_grab_ui.py".source = "${kitty-grab}/bin/_grab_ui.py";
    xdg.configFile."kitty/kitty_grab/kitten_options_definition.py".source = "${kitty-grab}/bin/kitten_options_definition.py";
    xdg.configFile."kitty/kitty_grab/kitten_options_parse.py".source = "${kitty-grab}/bin/kitten_options_parse.py";
    xdg.configFile."kitty/kitty_grab/kitten_options_types.py".source = "${kitty-grab}/bin/kitten_options_types.py";
    xdg.configFile."kitty/kitty_grab/kitten_options_utils.py".source = "${kitty-grab}/bin/kitten_options_utils.py";

    programs.kitty = {
      enable = true;

      font = {
        package = fantasque-sans-mono;
        name = "Fantasque Sans Mono";
        size = 13;
      };

      settings = {
        enable_audio_bell = false;
        update_check_interval = 0;
        kitty_mod = "ctrl+shift";
      };

      keybindings = {
        "shift+page_up" = "scroll_page_up";
        "shift+page_down" = "scroll_page_down";
        "shift+home" = "scroll_home";
        "shift+end" = "scroll_end";
        "kitty_mod+up" = "scroll_line_up";
        "kitty_mod+down" = "scroll_line_down";
        # Scroll to previous shell prompt
        "kitty_mod+z" = "scroll_to_prompt -1";
        # Browse output of last shell command in pager
        "kitty_mod+g" = "show_last_command_output";

        "ctrl+alt+enter" = "new_window";
        "kitty_mod+enter" = "launch --cwd=current";

        "kitty_mod+Insert" = "kitten kitty_grab/grab.py";

        #"kitty_mod+e" = "no_op";
        "kitty_mod+p>u" = "kitten hints --type url --program @";
        "kitty_mod+p>shift+u" = "kitten hints --type url --program -";
        "kitty_mod+p>alt+u" = "kitten hints --type url --program default";
        "kitty_mod+p>f" = "kitten hints --type path --program @";
        "kitty_mod+p>shift+f" = "kitten hints --type path --program -";
        "kitty_mod+p>alt+f" = "kitten hints --type path";
        "kitty_mod+p>l" = "kitten hints --type line --program @";
        "kitty_mod+p>shift+l" = "kitten hints --type line --program -";
        "kitty_mod+p>w" = "kitten hints --type word --program @";
        "kitty_mod+p>shift+w" = "kitten hints --type word --program -";
        "kitty_mod+p>h" = "kitten hints --type hash --program @";
        "kitty_mod+p>shift+h" = "kitten hints --type hash --program -";
        "kitty_mod+p>i" = "kitten hints --type ip --program @";
        "kitty_mod+p>shift+i" = "kitten hints --type ip --program -";
      };
    };

    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;

      signing = {
        signByDefault = false;
        key = "9454A24E1B5E963078B6E9317C02D10683ADCFB8";
      };

      userEmail = "Sighery@users.noreply.github.com";
      userName = "Sighery";

      includes = [
        {
          # path = "~/.config/git/helu.inc";
          # condition = "gitdir:i:${config.home.homeDirectory}/Helu/";
          condition = "gitdir:~/Helu/";
          contents = {
            user = {
              email = "nicholas@helu.io";
              name = "Nicholas Tarta";
            };
          };
        }
      ];

      extraConfig = {
        core = {
          pager = "less -x1,5";
        };

        status = {
          showUntrackedFiles = "all";
        };

        format = {
          pretty = "fuller";
        };
      };
    };

    programs.ssh = {
      enable = true;

      matchBlocks = {
        "github.com" = {
          user = "Sighery@users.noreply.github.com";
          identityFile = "~/.ssh/id_github";
          identitiesOnly = true;
          extraOptions."AddKeysToAgent" = "yes";
        };
        "github.com-helu" = {
          hostname = "github.com";
          user = "nicholas@helu.io";
          identityFile = "~/.ssh/helu";
          identitiesOnly = true;
          extraOptions."AddKeysToAgent" = "yes";
        };
        "gitlab.com" = {
          user = "4689618-Sighery@users.noreply.gitlab.com";
          identityFile = "~/.ssh/id_gitlab";
          extraOptions."AddKeysToAgent" = "yes";
        };
        "sigheryvps" = {
          hostname = "sighery.com";
          user = "sighery";
          identityFile = "~/.ssh/id_sigheryvps";
          extraOptions."AddKeysToAgent" = "yes";
        };
      };
    };

    programs.rofi = {
      enable = true;
      pass.enable = true;

      cycle = true;

      extraConfig = {
        modi = "combi,window,run,drun,ssh,keys";
        terminal = "rofi-sensible-terminal";
        "combi-modi" = "drun,run";
      };

      theme = let inherit (config.lib.formats.rasi) mkLiteral; in {
        "*" = {
          selected-normal-foreground = mkLiteral "rgba ( 51, 51, 51, 100 % )";
          foreground = mkLiteral "rgba ( 17, 170, 170, 100 % )";
          normal-foreground = mkLiteral "@foreground";
          alternate-normal-background = mkLiteral "rgba ( 255, 255, 255, 7 % )";
          red = mkLiteral "rgba ( 220, 50, 47, 100 % )";
          selected-urgent-foreground = mkLiteral "rgba ( 51, 51, 51, 100 % )";
          blue = mkLiteral "rgba ( 38, 139, 210, 100 % )";
          urgent-foreground = mkLiteral "rgba ( 255, 153, 153, 100 % )";
          alternate-urgent-background = mkLiteral "rgba ( 255, 255, 255, 7 % )";
          active-foreground = mkLiteral "rgba ( 170, 170, 17, 100 % )";
          lightbg = mkLiteral "rgba ( 238, 232, 213, 100 % )";
          selected-active-foreground = mkLiteral "rgba ( 51, 51, 51, 100 % )";
          alternate-active-background = mkLiteral "rgba ( 255, 255, 255, 7 % )";
          background = mkLiteral "rgba ( 51, 51, 51, 93 % )";
          bordercolor = mkLiteral "rgba ( 17, 170, 170, 100 % )";
          alternate-normal-foreground = mkLiteral "@foreground";
          normal-background = mkLiteral "rgba ( 0, 0, 0, 0 % )";
          lightfg = mkLiteral "rgba ( 88, 104, 117, 100 % )";
          selected-normal-background = mkLiteral "rgba ( 17, 170, 170, 100 % )";
          border-color = mkLiteral "@foreground";
          spacing = 2;
          separatorcolor = mkLiteral "rgba ( 17, 170, 170, 100 % )";
          urgent-background = mkLiteral "rgba ( 0, 0, 0, 0 % )";
          selected-urgent-background = mkLiteral "rgba ( 255, 153, 153, 100 % )";
          alternate-urgent-foreground = mkLiteral "@urgent-foreground";
          background-color = mkLiteral "rgba ( 0, 0, 0, 0 % )";
          alternate-active-foreground = mkLiteral "@active-foreground";
          active-background = mkLiteral "rgba ( 0, 0, 0, 0 % )";
          selected-active-background = mkLiteral "rgba ( 170, 170, 17, 100 % )";
          gruvbox-light-bg0-soft = mkLiteral "#f2e5bc";
          font = "Fantasque Sans Mono 13";
        };

        "window" = {
          background-color = mkLiteral "@background";
          border = mkLiteral "1px";
          padding = mkLiteral "5px";
          location = mkLiteral "north";
          width = mkLiteral "1920px";
          children = map mkLiteral [ "inputbar" "message" "listview" ];
        };

        "inputbar" = {
          spacing = 0;
          text-color = mkLiteral "@normal-foreground";
          padding = mkLiteral "1px";
          width = mkLiteral "100%";
          children = map mkLiteral [
            "prompt" "textbox-prompt-colon" "entry" "case-indicator" "mode-switcher"
          ];
        };

        "message" = {
          border = mkLiteral "1px dash 0px 0px";
          border-color = mkLiteral "@separatorcolor";
          padding = mkLiteral "1px";
        };

        "listview" = {
          layout = mkLiteral "horizontal";
          fixed-height = 1;
          border = mkLiteral "2px dash 0px 0px";
          border-color = mkLiteral "@separatorcolor";
          spacing = mkLiteral "5px";
          scrollbar = false;
          cycle = true;
          dynamic = false;
          padding = mkLiteral "2px";
          lines = 1000;
        };

        "prompt" = {
          spacing = 0;
          text-color = mkLiteral "@normal-foreground";
        };

        "textbox-prompt-colon" = {
          expand = false;
          str = ":";
          margin = mkLiteral "0px 0.3em 0em 0em";
          text-color = mkLiteral "@normal-foreground";
        };

        "entry" = {
          spacing = 0;
          text-color = mkLiteral "@normal-foreground";
        };

        "case-indicator" = {
          spacing = 0;
          text-color = mkLiteral "@normal-foreground";
        };

        "mode-switcher" = {
          spacing = mkLiteral "20px";
          width = mkLiteral "30%";
          border = mkLiteral "0px";
          background-color = mkLiteral "@gruvbox-light-bg0-soft";
        };

        "element" = {
          border = 0;
          padding = mkLiteral "1px";
        };

        "textbox" = {
          text-color = mkLiteral "@foreground";
        };

        "button selected" = {
          background-color = mkLiteral "@selected-normal-background";
          text-color = mkLiteral "@selected-normal-foreground";
        };

        "element normal.normal" = {
          background-color = mkLiteral "@normal-background";
          text-color = mkLiteral "@normal-foreground";
        };

        "element normal.urgent" = {
          background-color = mkLiteral "@urgent-background";
          text-color = mkLiteral "@urgent-foreground";
        };


        "element normal.active" = {
          background-color = mkLiteral "@active-background";
          text-color = mkLiteral "@active-foreground";
        };


        "element selected.normal" = {
          background-color = mkLiteral "@selected-normal-background";
          text-color = mkLiteral "@selected-normal-foreground";
        };


        "element selected.urgent" = {
          background-color = mkLiteral "@selected-urgent-background";
          text-color = mkLiteral "@selected-urgent-foreground";
        };


        "element selected.active" = {
          background-color = mkLiteral "@selected-active-background";
          text-color = mkLiteral "@selected-active-foreground";
        };


        "element alternate.normal" = {
          background-color = mkLiteral "@alternate-normal-background";
          text-color = mkLiteral "@alternate-normal-foreground";
        };

        "element alternate.urgent" = {
          background-color = mkLiteral "@alternate-urgent-background";
          text-color = mkLiteral "@alternate-urgent-foreground";
        };

        "element alternate.active" = {
          background-color = mkLiteral "@alternate-active-background";
          text-color = mkLiteral "@alternate-active-foreground";
        };
      };
    };

    xsession.windowManager.i3 = with lib; {
      enable = true;
      package = pkgs.i3-gaps;

      config = let
        mod = "Mod4";
        modeSystem = "(l)ock, (e)xit, switch_(u)ser, (s)uspend, (h)ibernate, (r)eboot, (Shift+s)hutdown";
        volumebin = "${i3-volume}/bin/i3-volume";
        statuscmd = "i3status";
        # i3blocks uses SIGRTMIN+10 by default, i3status uses SIGUSR1 by default
        statussig = "SIGUSR1";
        volumestep = "1";
        picturesDir = "${config.home.homeDirectory}/Pictures/";
        storeScreenshotCmd = "${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $f && mv $f ${picturesDir}";
      in {
        modifier = mod;

        workspaceAutoBackAndForth = true;

        fonts = {
          names = [ "Fantasque Sans Mono" ];
          #style = "monospace";
          size = 11.0;
        };

        window = {
          titlebar = false;
          border = 1;
          hideEdgeBorders = "none";
        };

        focus = {
          followMouse = true;
          forceWrapping = true;
          mouseWarping = true;
          newWindow = "smart";
        };

        colors = {
          background = "#2B2C2B";
          focused = {
            border = "#556064";
            background = "#556064";
            text = "#80FFF9";
            indicator = "#FDF6E3";
            childBorder = "#285577";
          };
          focusedInactive = {
            border = "#2F3D44";
            background = "#2F3D44";
            text = "#1ABC9C";
            indicator = "#454948";
            childBorder = "#5F676A";
          };
          unfocused = {
            border = "#2F3D44";
            background = "#2F3D44";
            text = "#1ABC9C";
            indicator = "#454948";
            childBorder = "#222222";
          };
          urgent = {
            border = "#CB4B16";
            background = "#FDF6E3";
            text = "#1ABC9C";
            indicator = "#268BD2";
            childBorder = "#900000";
          };
          placeholder = {
            border = "#000000";
            background = "#0C0C0C";
            text = "#FFFFFF";
            indicator = "#000000";
            childBorder = "#0C0C0C";
          };
        };

        floating = {
          modifier = mod;
          titlebar = true;

          criteria = [
            { class = "GParted"; }
            { class = "Pavucontrol"; }
            { class = "(?i)virtualbox"; }
          ];
        };

        gaps = {
          smartBorders = "on";
          smartGaps = true;
          inner = 1;
          outer = 0;
        };

        keybindings = {
          "${mod}+Shift+q" = "kill";

          "${mod}+f" = "fullscreen toggle";
          "${mod}+m" = "bar mode toggle";
          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+r" = "restart";
          "${mod}+Shift+e" =
            "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

          "${mod}+Return" = "exec ${pkgs.i3}/bin/i3-sensible-terminal";
          "${mod}+d" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show combi";
          "${mod}+F1" = "exec ${pkgs.vscodium}/bin/codium";
          "${mod}+F2" = "exec ${pkgs.brave}/bin/brave";
          "${mod}+Shift+F2" = "exec ${pkgs.firefox}/bin/firefox";
          "${mod}+F3" = "exec ${pkgs.i3}/bin/i3-sensible-terminal ${pkgs.ranger}/bin/ranger";
          "${mod}+Shift+F3" = "exec ${pkgs.pcmanfm}/bin/pcmanfm";
          "Print" = "exec --no-startup-id ${pkgs.scrot}/bin/scrot -e '${storeScreenshotCmd}'";
          "--release ${mod}+Print" = "exec --no-startup-id ${pkgs.scrot}/bin/scrot -u -e '${storeScreenshotCmd}'";
          "--release ${mod}+Shift+Print" = "exec --no-startup-id ${pkgs.scrot}/bin/scrot -s -f -e '${storeScreenshotCmd}'";

          "XF86AudioRaiseVolume" = "exec --no-startup-id ${volumebin} -ny -t ${statuscmd} -u ${statussig} up ${volumestep}";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${volumebin} -ny -t ${statuscmd} -u ${statussig} down ${volumestep}";
          "XF86AudioMute" = "exec --no-startup-id ${volumebin} -ny -t ${statuscmd} -u ${statussig} mute";
          #"XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
          #"XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
          #"XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";

          "${mod}+j" = "focus left";
          "${mod}+Left" = "focus left";
          "${mod}+k" = "focus down";
          "${mod}+Down" = "focus down";
          "${mod}+l" = "focus up";
          "${mod}+Up" = "focus up";
          "${mod}+semicolon" = "focus right";
          "${mod}+Right" = "focus right";

          "${mod}+Shift+j" = "move left";
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+k" = "move down";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+l" = "move up";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+semicolon" = "move right";
          "${mod}+Shift+Right" = "move right";

          "${mod}+Mod1+Left" = "move workspace to output left";
          "${mod}+Mod1+Down" = "move workspace to output down";
          "${mod}+Mod1+Up" = "move workspace to output up";
          "${mod}+Mod1+Right" = "move workspace to output right";

          "${mod}+b" = "workspace back_and_forth";
          "${mod}+Shift+b" =
            "move container to workspace back_and_forth; workspace back_and_forth";

          "${mod}+Ctrl+Left" = "workspace prev";
          "${mod}+Ctrl+Right" = "workspace next";

          "${mod}+h" = "split h";
          "${mod}+v" = "split v";
          "${mod}+q" = "split toggle";

          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          "${mod}+e" = "layout toggle split";

          # Change focus between tiling/floating windows
          "${mod}+space" = "focus mode_toggle";
          # Toggle tiling/floating
          "${mod}+Shift+space" = "floating toggle";
          # Toggle sticky
          "${mod}+Shift+s" = "sticky toggle";

          # Focus parent container
          "${mod}+a" = "focus parent";

          # Show the next scratchpad window or hide the focused scratchpad
          # window. If there are multiple scratchpad windows, this command
          # cycles through them.
          "${mod}+minus" = "scratchpad show";
          # Move the currently focused window to the scratchpad
          "${mod}+Shift+minus" = "move scratchpad";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";


          "${mod}+Shift+1" =
            "move container to workspace number 1; workspace number 1";
          "${mod}+Shift+2" =
            "move container to workspace number 2; workspace number 2";
          "${mod}+Shift+3" =
            "move container to workspace number 3; workspace number 3";
          "${mod}+Shift+4" =
            "move container to workspace number 4; workspace number 4";
          "${mod}+Shift+5" =
            "move container to workspace number 5; workspace number 5";
          "${mod}+Shift+6" =
            "move container to workspace number 6; workspace number 6";
          "${mod}+Shift+7" =
            "move container to workspace number 7; workspace number 7";
          "${mod}+Shift+8" =
            "move container to workspace number 8; workspace number 8";
          "${mod}+Shift+9" =
            "move container to workspace number 9; workspace number 9";


          "${mod}+Ctrl+1" = "move container to workspace number 1";
          "${mod}+Ctrl+2" = "move container to workspace number 2";
          "${mod}+Ctrl+3" = "move container to workspace number 3";
          "${mod}+Ctrl+4" = "move container to workspace number 4";
          "${mod}+Ctrl+5" = "move container to workspace number 5";
          "${mod}+Ctrl+6" = "move container to workspace number 6";
          "${mod}+Ctrl+7" = "move container to workspace number 7";
          "${mod}+Ctrl+8" = "move container to workspace number 8";
          "${mod}+Ctrl+9" = "move container to workspace number 9";

          "${mod}+r" = "mode resize";
          "${mod}+0" = ''mode "${modeSystem}"'';
        };

        modes = {
          resize = {
            j = "resize shrink width 5 px or 5 ppt";
            k = "resize grow height 5 px or 5 ppt";
            l = "resize shrink height 5 px or 5 ppt";
            semicolon = "resize grow width 5 px or 5 ppt";

            Left = "resize shrink width 1 px or 1 ppt";
            Down = "resize grow height 1 px or 1 ppt";
            Up = "resize shrink height 1 px or 1 ppt";
            Right = "resize grow width 1 px or 1 ppt";

            "Shift+Left" = "resize shrink width 5 px or 5 ppt";
            "Shift+Down" = "resize grow height 5 px or 5 ppt";
            "Shift+Up" = "resize shrink height 5 px or 5 ppt";
            "Shift+Right" = "resize grow width 5 px or 5 ppt";

            Return = "mode default";
            Escape = "mode default";
          };

          "${modeSystem}" = {
            l = "exec --no-startup-id ${pkgs.xsecurelock}/bin/xsecurelock, mode default";
            s = "exec --no-startup-id systemctl suspend, mode default";
            u = "exec --no-startup-id dm-tool switch-to-greeter, mode default";
            e = "exec --no-startup-id exit, mode default";
            h = "exec --no-startup-id systemctl hibernate, mode default";
            r = "exec --no-startup-id systemctl reboot, mode default";
            "Shift+s" = "exec --no-startup-id systemctl poweroff, mode default";

            Return = "mode default";
            Escape = "mode default";
          };
        };

        bars = [{
          position = "bottom";
          command = "${pkgs.i3-gaps}/bin/i3bar";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          trayOutput = "primary";
          mode = "hide";
          hiddenState = "hide";
          workspaceButtons = true;

          colors = {
            background = "#222D31";
            statusline = "#F9FAF9";
            separator = "#454947";

            focusedWorkspace = {
              border = "#F9FAF9";
              background = "#16A085";
              text = "#292F34";
            };
            activeWorkspace = {
              border = "#595B5B";
              background = "#353836";
              text = "#FDF6E3";
            };
            inactiveWorkspace = {
              border = "#595B5B";
              background = "#222D31";
              text = "#EEE8D5";
            };
            bindingMode = {
              border = "#16A085";
              background = "#2C2C2C";
              text = "#F9FAF9";
            };
            urgentWorkspace = {
              border = "#16A085";
              background = "#FDF6E3";
              text = "#E5201D";
            };
          };
        }];
      };
    };
  };

  boot.supportedFilesystems = [ "ntfs" ];

  #boot.kernelModules = [
  #  "i2c-dev"
  #];

  boot.loader = {
    systemd-boot.enable = false;

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    grub = {
      enable = true;
      version = 2;

      devices = [ "nodev" ];
      default = 1;
      efiSupport = true;
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root D493-80C4
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  #networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  #networking.firewall.allowedTCPPorts = [ 8000 ];

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  #networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #let
  #  pkgs = import (builtins.fetchGit {
  #    name = "fantasque-sans-mono-v1.7.2";
  #    url = "https://github.com/NixOS/nixpkgs/";
  #    ref = "refs/heads/nixos-20.03";
  #    rev = "b5b7bd6ebba2a165e33726b570d7ab35177cf951";
  #  }) {};
  #in {
  #  fonts.fonts = with pkgs; [
  #    pkgs.fantasque-sans-mono;
  #  ];
  #}
  #
  #nixpkgs.config.packageOverrides = pkgs: rec {
  #  fantasque-sans-mono = pkgs.fantasque-sans-mono.overrideAttrs (oldAttrs: rec {
  #    version = "1.7.2";
  #  });
  #};
  #pkgs.fantasque-sans-mono.overrideAttrs
  #
  # nixpkgs.overlays = [ (self: super: {
  #   fantasque-sans-mono = super.fantasque-sans-mono.overrideAttrs (old: {
  #     version = "1.7.2";
  #   });
  # }) ];

  #nixpkgs.config.packageOverrides = pkgs: rec {
  #  fantasque-sans-mono = pkgs.callPackage fonts/fantasque-sans-mono {};
  #};

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  services.picom.enable = true;
  services.plex.enable = true;

  fonts = {
    enableDefaultFonts = true;

    fonts = [
      fantasque-sans-mono
    ];

    #fontconfig = {
    #  localConf = ''
    #    <match target='font'>
    #      <test name='fontformat' compare='not_eq'>
    #        <string/>
    #      </test>
    #      <test name='family'>
    #        <string>Fantasque Sans Mono</string>
    #      </test>
    #      <edit name='fontfeatures' mode='assign_replace'>
    #        <string>ss01</string>
    #      </edit>
    #    </match>
    #  '';
    #};

    fontconfig = {
      defaultFonts = {
        monospace = [ "FantasqueSansMono" ];
      };
    };
  };



  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "FantasqueSansMono";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;

    videoDrivers = [ "nvidia" ];

    screenSection = ''
      Option "metamodes" "DP-4: 5120x1440_120 +0+0; DP-4: nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option "AllowIndirectGLXProtocol" "off"
      Option "TripleBuffer" "on"
    '';

    xrandrHeads = [
      {
        output = "DP-4";
        primary = true;
        monitorConfig = ''
          ModeLine "5120x1440_120.00"  1322.75  5120 5560 6128 7136  1440 1443 1453 1545 -hsync +vsync
          VertRefresh 120
          Option "PreferredMode" "5120x1440"
        '';
      }
      {
        output = "HDMI-1";
        monitorConfig = ''
          Option "Enable" "false"
        '';
      }
    ];

    layout = "us";

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";

      lightdm = {
        enable = true;

        extraSeatDefaults = ''
          greeter-hide-users=true
          greeter-show-manual-login=true
          allow-guest=false
          greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
        '';
      };
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;

      extraPackages = with pkgs; [
        rofi
        i3status
      ];
    };
  };

  # Configure keymap in X11
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;

    # Enable connecting with A2DP profile
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  services.blueman.enable = true;

  # Enable sound.
  sound = {
    enable = true;

    mediaKeys = {
      enable = true;
      volumeStep = "1%";
    };
  };

  hardware.pulseaudio = {
    enable = true;

    package = pkgs.pulseaudioFull;
    # Enable extra BT codecs (AAC, APTX, APTX-HD, LDAC)
    extraModules = [ pkgs.pulseaudio-modules-bt ];

    extraConfig = ''
      #load-module module-switch-on-connect
      #load-module module-switch-on-port-available
      #unload-module module-switch-on-connect
      unload-module module-switch-on-port-available
      set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo
    '';
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Logitech Unifying Receiver
  hardware.logitech = {
    wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  programs.adb.enable = true;

  programs.bash = {
    promptInit = ''
      # Provide a nice prompt if the terminal supports it.
      if [ "$TERM" != "dumb" -o -n "$INSIDE_EMACS" ]; then
        PROMPT_COLOR="1;31m"
        let $UID && PROMPT_COLOR="1;32m"
        if [ -n "$INSIDE_EMACS" -o "$TERM" == "eterm" -o "$TERM" == "eterm-color" ]; then
          # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
          PS1="\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
        else
          PS1="\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
        fi
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      fi
    '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sighery = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "audio" "adbusers" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGtOebXo7U41W/niaRK3cd3IYdhF5rS2VQdozYLPhiG4 helu-laptop"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim moreutils
    dbeaver
    gnome3.gnome-disk-utility dconf
    gnome.cheese gnome.gnome-keyring gnome.seahorse
    ddrescue
    smartmontools
    gimp
    vlc
    libreoffice
    qbittorrent
    brave firefox nyxt
    kitty kitty-grab python39Packages.pygments
    numlockx
    home-manager
    gparted parted
    keepassxc
    git tig
    zip unzip
    #vscodium-with-extensions
    pavucontrol ncpamixer
    xidlehook
    clementine
    i3-resurrect
    i3-volume dunst libnotify
    #dunst herbe
    exa
    rofi rofi-pass
    yq
    colordiff
    scrot peek
    docker docker-compose
    spotify
    xsecurelock
    xclip
    zbar
    jmtpfs
    khal
    ranger pcmanfm lxmenu-data shared_mime_info
    foliate calibre
  ];

  environment.shellAliases = {
    ls = "exa -F";
    exa = "exa -F";
    grep = "grep --colour=auto";
    egrep = "egrep --colour=auto";
    fgrep = "fgrep --colour=auto";
    cp = "cp -i";
    less = "less -x4 -R";
    more = "less -x4 -R";
    ll = "exa --long --git --header --links --group --classify";
    exal = "exa --long --git --header --links --group --classify";
    la = "exa --all --classify";
    exaa = "exa --all --classify";
    exala = "exa --all --long --git --header --links --group --classify";
    kitten = "kitty +kitten";
    diff = "colordiff -u";
    colordiff = "colordiff -u";

    awslocal = "aws --endpoint-url http://localhost:4566";
  };

  programs.vim.defaultEditor = true;
  programs.dconf.enable = true;

  environment.variables = {
    #EDITOR = "vim";
    #VISUAL = "vim";
    BROWSER = "brave";
    TERMINAL = "kitty";
    TERMCDM = "kitty";
    PAGER = "less";

    XSECURELOCK_PASSWORD_PROMPT = "time";
    XSECURELOCK_SHOW_HOSTNAME = "0";
    XSECURELOCK_SHOW_USERNAME = "0";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    #enableSSHSupport = true;
  };
  programs.ssh.startAgent = true;

  # List services that you want to enable:
  # USB Automounting
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Virtualisation
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

