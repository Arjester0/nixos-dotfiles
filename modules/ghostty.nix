{ config, pkgs, ... }:

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

      gtk-tabs-location = "hidden";
      gtk-single-instance = false;

      resize-overlay = "never";
      mouse-hide-while-typing = true;

      shell-integration = "detect";
      shell-integration-features = "cursor,sudo,title";

      confirm-close-surface = false;
      copy-on-select = true;

      # NCC uses 100 MiB rather than 20,000 bytes.
      scrollback-limit = 100 * 1024 * 1024;

      # NCC behavior.
      mouse-scroll-multiplier = "discrete:1";
      quit-after-last-window-closed = true;

      # Keep the terminal visually minimal in Ghostty 1.3+.
      scrollbar = "never";

      # ------------------------------------------------------------
      # NCC-style functionality
      # ------------------------------------------------------------

      keybind = [
        # Clipboard
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"

        # Jump between shell prompts.
        # Requires working shell integration.
        "ctrl+shift+z=jump_to_prompt:-2"
        "ctrl+shift+x=jump_to_prompt:2"

        # Write scrollback to a temporary file and paste its path.
        "ctrl+shift+h=write_scrollback_file:paste"

        # Ghostty inspector
        "ctrl+shift+i=inspector:toggle"

        # Scroll by one third of a page.
        "ctrl+shift+page_down=scroll_page_fractional:0.33"
        "ctrl+shift+page_up=scroll_page_fractional:-0.33"

        # Scroll one line at a time.
        "ctrl+shift+down=scroll_page_lines:1"
        "ctrl+shift+j=scroll_page_lines:1"
        "ctrl+shift+up=scroll_page_lines:-1"
        "ctrl+shift+k=scroll_page_lines:-1"

        # Scrollback boundaries.
        "ctrl+shift+home=scroll_to_top"
        "ctrl+shift+end=scroll_to_bottom"

        # Font controls.
        "ctrl+shift+enter=reset_font_size"
        "ctrl+shift+plus=increase_font_size:1"
        "ctrl+shift+minus=decrease_font_size:1"

        # Window and surface management.
        "ctrl+shift+t=new_window"
        "ctrl+shift+q=close_surface"

        # Direct tab selection.
        "ctrl+shift+one=goto_tab:1"
        "ctrl+shift+two=goto_tab:2"
        "ctrl+shift+three=goto_tab:3"
        "ctrl+shift+four=goto_tab:4"
        "ctrl+shift+five=goto_tab:5"
        "ctrl+shift+six=goto_tab:6"
        "ctrl+shift+seven=goto_tab:7"
        "ctrl+shift+eight=goto_tab:8"
        "ctrl+shift+nine=goto_tab:9"
        "ctrl+shift+zero=goto_tab:10"

        # Tab navigation.
        "ctrl+tab=next_tab"
        "ctrl+shift+tab=previous_tab"

        # Useful Ghostty 1.3 feature: native scrollback search.
        "ctrl+shift+f=start_search"
      ];
    };
  };

  # Ensure the configured font is available.
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
