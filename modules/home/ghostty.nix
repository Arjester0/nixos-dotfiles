{
  programs.ghostty = {
    enable = true;

    settings = {
      theme = "Gruvbox Dark Hard";

      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;

      font-style = "Regular";
      font-style-bold = "Bold";
      font-style-italic = "Italic";
      font-style-bold-italic = "Bold Italic";

      cursor-style = "bar";
      cursor-style-blink = true;

      window-decoration = false;
      window-padding-x = 10;
      window-padding-y = 9;
      window-padding-balance = true;
      background-opacity = 0.82;

      window-show-tab-bar = "always";
      gtk-single-instance = false;

      resize-overlay = "never";
      mouse-hide-while-typing = true;

      shell-integration = "detect";
      shell-integration-features = "cursor,sudo,title";

      confirm-close-surface = false;
      copy-on-select = true;
      scrollback-limit = 100 * 1024 * 1024;

      split-divider-color = "#665c54";

      keybind = [
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"

        "ctrl+shift+t=new_tab"
        "ctrl+shift+w=close_tab"

        "ctrl+tab=next_tab"
        "ctrl+shift+tab=previous_tab"

        "ctrl+shift+one=goto_tab:1"
        "ctrl+shift+two=goto_tab:2"
        "ctrl+shift+three=goto_tab:3"
        "ctrl+shift+four=goto_tab:4"
        "ctrl+shift+five=goto_tab:5"
        "ctrl+shift+six=goto_tab:6"
        "ctrl+shift+seven=goto_tab:7"
        "ctrl+shift+eight=goto_tab:8"
        "ctrl+shift+nine=goto_tab:9"

        "ctrl+shift+r=prompt_tab_title"

        "ctrl+shift+backslash=new_split:right"
        "ctrl+shift+minus=new_split:down"

        "ctrl+shift+q=close_surface"

        "ctrl+alt+h=goto_split:left"
        "ctrl+alt+j=goto_split:down"
        "ctrl+alt+k=goto_split:up"
        "ctrl+alt+l=goto_split:right"

        "ctrl+alt+left=goto_split:left"
        "ctrl+alt+down=goto_split:down"
        "ctrl+alt+up=goto_split:up"
        "ctrl+alt+right=goto_split:right"

        "ctrl+shift+alt+h=resize_split:left,10"
        "ctrl+shift+alt+j=resize_split:down,10"
        "ctrl+shift+alt+k=resize_split:up,10"
        "ctrl+shift+alt+l=resize_split:right,10"

        "ctrl+shift+e=equalize_splits"
        "ctrl+shift+f=toggle_split_zoom"

        "ctrl+shift+z=jump_to_prompt:-1"
        "ctrl+shift+x=jump_to_prompt:1"

        "ctrl+shift+page_down=scroll_page_fractional:0.33"
        "ctrl+shift+page_up=scroll_page_fractional:-0.33"

        "ctrl+shift+home=scroll_to_top"
        "ctrl+shift+end=scroll_to_bottom"

        "ctrl+shift+i=inspector:toggle"
        "ctrl+shift+s=start_search"

        "ctrl+shift+enter=reset_font_size"
        "ctrl+plus=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"

        "ctrl+shift+n=new_window"
      ];
    };
  };
}
