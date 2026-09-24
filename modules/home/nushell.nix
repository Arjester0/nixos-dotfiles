{
  programs.nushell = {
    enable = true;

    shellAliases = {
      cat = "bat";
      grep = "rg";
      find = "fd";

      g = "git";
      gs = "git status";
      gd = "git diff";
      gl = "git log";
      lg = "lazygit";

      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#arjester";
      test-system = "sudo nixos-rebuild test --flake ~/nixos-dotfiles#arjester";
      check-system = "sudo nixos-rebuild dry-build --flake ~/nixos-dotfiles#arjester";
      check-flake = "nix flake check ~/nixos-dotfiles";
    };

    extraEnv = ''
      $env.config.show_banner = false
      $env.config.edit_mode = "vi"
      $env.config.buffer_editor = "hx"

      # Shared searchable history across Ghostty tabs and panes.
      $env.config.history = {
        file_format: sqlite
        max_size: 1_000_000
        sync_on_enter: true
        isolation: false
      }

      # Fish-like completion behavior.
      $env.config.completions = {
        case_sensitive: false

        # Automatically select the completion when only one remains.
        quick: true

        # Complete as much of the common prefix as possible.
        partial: true

        # Match text even when it is not an exact prefix.
        algorithm: fuzzy

        sort: smart

        external: {
          enable: true
          max_results: 100
        }
      }

      $env.config.cursor_shape = {
        emacs: line
        vi_insert: line
        vi_normal: block
      }

      $env.config.table = {
        mode: rounded
        index_mode: auto
        show_empty: true

        trim: {
          methodology: wrapping
          wrapping_try_keep_words: true
        }
      }

      # Tab opens/cycles the completion menu.
      $env.config.keybindings ++= [
        {
          name: completion_menu
          modifier: none
          keycode: tab
          mode: [emacs vi_normal vi_insert]
          event: {
            until: [
              { send: menu name: completion_menu }
              { send: menunext }
              { edit: complete }
            ]
          }
        }

        {
          name: completion_menu_previous
          modifier: shift
          keycode: backtab
          mode: [emacs vi_normal vi_insert]
          event: {
            until: [
              { send: menuprevious }
              { send: menu name: completion_menu }
            ]
          }
        }

        # Fish-style searchable history menu.
        {
          name: history_menu
          modifier: control
          keycode: char_r
          mode: [emacs vi_normal vi_insert]
          event: {
            until: [
              { send: menu name: history_menu }
              { send: menupagenext }
            ]
          }
        }
      ]
    '';

    extraConfig = ''
      def --env mkcd [directory: path] {
        mkdir $directory
        cd $directory
      }

      def extract [archive: path] {
        ouch decompress $archive
      }

      def nix-clean [] {
        sudo nix-collect-garbage
        nix-collect-garbage
      }
    '';
  };

  # External completions for git, cargo, nix, systemctl, Docker,
  # Kubernetes, GitHub CLI and many other programs.
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
    options = [
      "--cmd"
      "z"
    ];
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;

    settings = {
      add_newline = false;
      command_timeout = 1000;

      character = {
        success_symbol = "[❯](bold cyan)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold cyan)";
      };

      directory = {
        truncation_length = 4;
        truncate_to_repo = false;
      };

      git_status = {
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
      };

      nix_shell = {
        symbol = " ";
        format = "via [$symbol$name]($style) ";
      };
    };
  };

}
