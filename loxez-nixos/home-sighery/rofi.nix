{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.rofi = {
    enable = true;
    pass.enable = true;

    cycle = true;

    extraConfig = {
      modi = "combi,window,run,drun,ssh,keys";
      terminal = "rofi-sensible-terminal";
      "combi-modi" = "drun,run";
    };

    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
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
          children = map mkLiteral [
            "inputbar"
            "message"
            "listview"
          ];
        };

        "inputbar" = {
          spacing = 0;
          text-color = mkLiteral "@normal-foreground";
          padding = mkLiteral "1px";
          width = mkLiteral "100%";
          children = map mkLiteral [
            "prompt"
            "textbox-prompt-colon"
            "entry"
            "case-indicator"
            "mode-switcher"
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
}
