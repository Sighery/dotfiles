{ config, lib, pkgs, ... }:

{
  programs.swaylock.enable = true;
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    systemd.enable = true;
    xwayland = true;

    config = rec {
      terminal = "kitty";
      menu = "wofi --show run,drun";
      defaultWorkspace = "1";
      modifier = "Mod4";

      fonts = {
        names = [ "Fantasque Sans Mono" ];
        style = "Regular";
        size = 11.0;
      };

      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
      in lib.mkOptionDefault {
        "${mod}+Shift+q" = "kill";

        "${mod}+f" = "fullscreen toggle";
        "${mod}+m" = "bar mode toggle";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        # "${mod}+Shift+e" =
        #   "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

        "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${mod}+d" = "exec --no-startup-id ${pkgs.wofi}/bin/wofi --show run,drun";
        "${mod}+F1" = "exec ${pkgs.vscodium}/bin/codium";
        "${mod}+F2" = "exec ${pkgs.brave}/bin/brave";
        "${mod}+Shift+F2" = "exec ${pkgs.firefox}/bin/firefox";
        "${mod}+F3" = "exec ${pkgs.kitty}/bin/kitty ${pkgs.ranger}/bin/ranger";
        "${mod}+Shift+F3" = "exec ${pkgs.pcmanfm}/bin/pcmanfm";
        # "Print" = "exec --no-startup-id ${pkgs.scrot}/bin/scrot -e '${storeScreenshotCmd}'";
        # "--release ${mod}+Print" = "exec --no-startup-id ${pkgs.scrot}/bin/scrot -u -e '${storeScreenshotCmd}'";
        # "--release ${mod}+Shift+Print" = "exec --no-startup-id ${pkgs.scrot}/bin/scrot -s -f -e '${storeScreenshotCmd}'";

        #"XF86AudioRaiseVolume" = "exec --no-startup-id ${volumebin} -ny -t ${statuscmd} -u ${statussig} up ${volumestep}";
        #"XF86AudioLowerVolume" = "exec --no-startup-id ${volumebin} -ny -t ${statuscmd} -u ${statussig} down ${volumestep}";
        #"XF86AudioMute" = "exec --no-startup-id ${volumebin} -ny -t ${statuscmd} -u ${statussig} mute";
        # "XF86AudioRaiseVolume" = "exec --no-startup-id ${volumebin} set-volume @DEFAULT_AUDIO_SINK@ ${volumestep}%+ && ${audionotif}";
        # "XF86AudioLowerVolume" = "exec --no-startup-id ${volumebin} set-volume @DEFAULT_AUDIO_SINK@ ${volumestep}%- && ${audionotif}";
        # "XF86AudioMute" = "exec --no-startup-id ${volumebin} set-mute @DEFAULT_AUDIO_SINK@ toggle && ${audionotif}";
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
        #"${mod}+0" = ''mode "${modeSystem}"'';
      };

      bars = [{
        fonts.size = 15.0;
        position = "bottom";
      }];

      output = {
        "DP-5" = {
          scale = "1";
	  mode = "5120x1440@239.761Hz";
        };
      };
    };
  };
}
