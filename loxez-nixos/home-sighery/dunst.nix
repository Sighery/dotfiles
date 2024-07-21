{ config, lib, pkgs, ... }:

{
  services.dunst = {
    enable = true;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = "16x16";
    };

    settings = {
      global = {
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
}
