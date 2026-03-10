{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = false;  # keep nvim as default, hx to launch helix

    settings = {
      theme = "gruvbox";

      editor = {
        auto-completion = true;
        bufferline = "multiple";
        completion-trigger-len = 2;
        line-number = "absolute";
        mouse = false;
        color-modes = true;

        auto-save.focus-lost = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker.hidden = false;

        inline-diagnostics = {
          cursor-line = "warning";
          other-lines = "error";
        };

        lsp.display-inlay-hints = true;

        soft-wrap.enable = true;

        statusline = {
          left = [ "mode" "spinner" ];
          center = [ "file-name" ];
          right = [ "diagnostics" "selections" "position" "file-encoding" "file-type" ];
          separator = "│";
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
      };

      # Make w/e/b collapse selection after moving (more vim-like)
      keys.normal = {
        w = [ "move_next_word_start" "collapse_selection" ];
        e = [ "move_next_word_end" "collapse_selection" ];
        b = [ "move_prev_word_start" "collapse_selection" ];
        W = [ "move_next_long_word_start" "collapse_selection" ];
        E = [ "move_next_long_word_end" "collapse_selection" ];
        B = [ "move_prev_long_word_start" "collapse_selection" ];
      };

      keys.insert = {
        esc = [ "collapse_selection" "normal_mode" ];
      };
    };

    languages = {
      language-server = {
        nixd = {
          command = "nixd";
        };
        rust-analyzer = {
          config.check.command = "clippy";
        };
      };

      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = { command = "nixfmt"; };
          language-servers = [ "nixd" ];
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" ];
        }
        {
          name = "python";
          auto-format = true;
          formatter = { command = "ruff"; args = [ "format" "-" ]; };
        }
      ];
    };
  };
}
