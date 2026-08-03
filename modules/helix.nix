{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "wallust";

      editor = {
        shell = [
          "nu"
          "--commands"
        ];

        auto-completion = true;
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
          character = "| ";
        };

        file-picker.hidden = false;

        inline-diagnostics = {
          cursor-line = "warning";
          other-lines = "error";
        };

        lsp.display-inlay-hints = true;

        soft-wrap.enable = true;

        statusline = {
          left = [
            "mode"
            "spinner"
          ];
          center = [ "file-name" ];
          right = [
            "diagnostics"
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

      keys.insert = {
        esc = [
          "collapse_selection"
          "normal_mode"
        ];

        normal = {
          D = "extend_to_line_end";
          C-s = ":write";
        };

        select = {
          D = "extend_to_line_end";
        };

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
        nil = {
          command = "nil";
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
          language-servers = [ "nil" ];
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" ];
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

    extraPackages = with pkgs; [
      basedpyright
      bash-language-server
      clang-tools
      deno
      gopls
      lua-language-server
      marksman
      nil
      nixfmt
      rust-analyzer
      taplo
      texlab
      vscode-langservers-extended
      yaml-language-server
    ];
  };
}
