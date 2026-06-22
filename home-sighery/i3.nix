{ config
, lib
, pkgs
, ...
}:

{
  xsession.windowManager.i3 = with lib; {
    enable = true;
    package = pkgs.i3;

    config =
      let
        mod = "Mod4";
        modeSystem = "(l)ock, (e)xit, switch_(u)ser, (s)uspend, (h)ibernate, (r)eboot, (Shift+s)hutdown";
        #volumebin = "${i3-volume}/bin/i3-volume";
        volumebin = "${pkgs.wireplumber}/bin/wpctl";
        audionotif = "${pkgs.audio-notification}/bin/audio-notification";
        statuscmd = "i3status";
        # i3blocks uses SIGRTMIN+10 by default, i3status uses SIGUSR1 by default
        statussig = "SIGUSR1";
        volumestep = "1";
        picturesDir = "${config.home.homeDirectory}/Pictures/";
        storeScreenshotCmd = "${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $f && mv $f ${picturesDir}";
      in
      {
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
          wrapping = "yes";
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
          "${mod}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

          "${mod}+Return" = "exec ${pkgs.i3}/bin/i3-sensible-terminal";
          "${mod}+d" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show combi";
          "${mod}+F1" = "exec ${pkgs.vscodium}/bin/codium";
          "${mod}+F2" = "exec ${pkgs.brave}/bin/brave --password-store=basic";
          "${mod}+Shift+F2" = "exec ${pkgs.firefox}/bin/firefox";
          "${mod}+F3" = "exec ${pkgs.i3}/bin/i3-sensible-terminal ${pkgs.ranger}/bin/ranger";
          "${mod}+Shift+F3" = "exec ${pkgs.kdePackages.dolphin}/bin/dolphin";
          "Print" = "exec --no-startup-id ${pkgs.scrot}/bin/scrot -e '${storeScreenshotCmd}'";
          "--release ${mod}+Print" =
            "exec --no-startup-id ${pkgs.scrot}/bin/scrot -u -e '${storeScreenshotCmd}'";
          "--release ${mod}+Shift+Print" =
            "exec --no-startup-id ${pkgs.scrot}/bin/scrot -s -f -e '${storeScreenshotCmd}'";

          #"XF86AudioRaiseVolume" = "exec --no-startup-id ${volumebin} -ny -t ${statuscmd} -u ${statussig} up ${volumestep}";
          #"XF86AudioLowerVolume" = "exec --no-startup-id ${volumebin} -ny -t ${statuscmd} -u ${statussig} down ${volumestep}";
          #"XF86AudioMute" = "exec --no-startup-id ${volumebin} -ny -t ${statuscmd} -u ${statussig} mute";
          #"XF86AudioRaiseVolume" = "exec --no-startup-id ${volumebin} set-volume @DEFAULT_AUDIO_SINK@ ${volumestep}%+ && ${audionotif}";
          #"XF86AudioLowerVolume" = "exec --no-startup-id ${volumebin} set-volume @DEFAULT_AUDIO_SINK@ ${volumestep}%- && ${audionotif}";
          #"XF86AudioMute" = "exec --no-startup-id ${volumebin} set-mute @DEFAULT_AUDIO_SINK@ toggle && ${audionotif}";
          "XF86AudioMute" = "exec --no-startup-id ${volumebin} set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioRaiseVolume" =
            "exec --no-startup-id ${volumebin} set-volume @DEFAULT_AUDIO_SINK@ ${volumestep}%+ && ${audionotif}";
          "XF86AudioLowerVolume" =
            "exec --no-startup-id ${volumebin} set-volume @DEFAULT_AUDIO_SINK@ ${volumestep}%- && ${audionotif}";
          "Shift+XF86AudioRaiseVolume" =
            "exec --no-startup-id ${volumebin} set-volume @DEFAULT_AUDIO_SINK@ 5%+ && ${audionotif}";
          "Shift+XF86AudioLowerVolume" =
            "exec --no-startup-id ${volumebin} set-volume @DEFAULT_AUDIO_SINK@ 5%- && ${audionotif}";
          #"XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
          #"XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
          #"XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioPlay" =
            ''exec --no-startup-id "${pkgs.playerctl}/bin/playerctl --player=spotify,%any play-pause"'';
          "XF86AudioPause" =
            ''exec --no-startup-id "${pkgs.playerctl}/bin/playerctl --player=spotify,%any play-pause"'';
          "XF86AudioNext" =
            ''exec --no-startup-id "${pkgs.playerctl}/bin/playerctl --player=spotify,%any next"'';
          "XF86AudioPrev" =
            ''exec --no-startup-id "${pkgs.playerctl}/bin/playerctl --player=spotify,%any previous"'';

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
          "${mod}+Shift+b" = "move container to workspace back_and_forth; workspace back_and_forth";

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

          # Focus parent/child container
          "${mod}+a" = "focus parent";
          "${mod}+Shift+a" = "focus child";

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

          "${mod}+Shift+1" = "move container to workspace number 1; workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2; workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3; workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4; workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5; workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6; workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7; workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8; workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9; workspace number 9";

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

            r = "exec --no-startup-id ${pkgs.i3-balance-workspace}/bin/i3_balance_workspace";

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

        bars = [
          {
            position = "bottom";
            command = "${pkgs.i3}/bin/i3bar";
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
          }
        ];
      };
  };
}
