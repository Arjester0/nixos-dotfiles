{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "gruvbox_dark_hard";

      editor = {
        shell = [
          "nu"
          "--commands"
        ];

        auto-completion = false;
        cursorline = true;
        true-color = true;
        auto-format = true;
        bufferline = "multiple";
        completion-trigger-len = 2;
        line-number = "relative";
        mouse = false;
        color-modes = true;

        auto-save.focus-lost = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        indent-guides = {
          render = true;
          character = "▏";
        };

        file-picker.hidden = false;

        # Keep goto-definition without intrusive diagnostics or inlay hints.
        gutters = [ "spacer" "line-numbers" "spacer" "diff" ];
        end-of-line-diagnostics = "disable";
        lsp.display-inlay-hints = false;

        soft-wrap.enable = true;

        statusline = {
          left = [
            "mode"
            "spinner"
          ];
          center = [ "file-name" ];
          right = [
            "selections"
            "position"
            "file-encoding"
            "file-type"
          ];
          separator = "│";
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
      };

      keys.normal = {
        D = "extend_to_line_end";
        C-s = ":write";
      };

      keys.select = {
        D = "extend_to_line_end";
      };

      keys.insert = {
        esc = [
          "collapse_selection"
          "normal_mode"
        ];

        j = {
          k = [
            "collapse_selection"
            "normal_mode"
          ];
        };
      };
    };

    languages = {
      language-server = {
        nixd = {
          command = "nixd";
        };
        rust-analyzer = {
          config.cargo.features = "all";
          config.check.command = "clippy";
        };
      };

      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt";
          };
          language-servers = [ { name = "nixd"; except-features = [ "completion" "diagnostics" ]; } ];
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = [ { name = "rust-analyzer"; except-features = [ "completion" "diagnostics" ]; } ];
        }
        {
          name = "python";
          auto-format = true;
          formatter = {
            command = "ruff";
            args = [
              "format"
              "-"
            ];
          };
        }
      ];
    };

  };
}
