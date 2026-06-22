{ config
, lib
, pkgs
, ...
}:

{
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
  # xdg.configFile."kitty/kitty_grab/grab.py".source = "${kitty-grab}/bin/grab.py";
  # xdg.configFile."kitty/kitty_grab/_grab_ui.py".source = "${kitty-grab}/bin/_grab_ui.py";
  # xdg.configFile."kitty/kitty_grab/kitten_options_definition.py".source = "${kitty-grab}/bin/kitten_options_definition.py";
  # xdg.configFile."kitty/kitty_grab/kitten_options_parse.py".source = "${kitty-grab}/bin/kitten_options_parse.py";
  # xdg.configFile."kitty/kitty_grab/kitten_options_types.py".source = "${kitty-grab}/bin/kitten_options_types.py";
  # xdg.configFile."kitty/kitty_grab/kitten_options_utils.py".source = "${kitty-grab}/bin/kitten_options_utils.py";

  programs.kitty = {
    enable = true;

    font = {
      name = "Fantasque Sans Mono";
      size = 13;
    };

    settings = {
      enable_audio_bell = false;
      update_check_interval = 0;
      kitty_mod = "ctrl+shift";
      enabled_layouts = "vertical,fat,grid,horizontal,stack,tall";
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

      "ctrl+alt+g" = "launch --stdin-source=@last_cmd_output ${pkgs.xclip} -in -selection clipboard";
    };
  };
}
