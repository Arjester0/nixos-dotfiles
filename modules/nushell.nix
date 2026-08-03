{ config, ... }:

{
  programs.nushell = {
    enable = true;

    environmentVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      TERMINAL = "ghostty";
      BROWSER = "brave";
      PAGER = "less -FR";
    };

    shellAliases = {
      # Files and search
      cat = "bat";
      grep = "rg";
      find = "fd";

      # NixOS
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#arjester";
      build-system = "sudo nixos-rebuild build --flake ~/nixos-dotfiles#arjester";
      check-system = "nix flake check ~/nixos-dotfiles";
      update-system = "nix flake update --flake ~/nixos-dotfiles";

      # Git
      g = "git";
      ga = "git add";
      gc = "git commit";
      gd = "git diff";
      gl = "git log";
      gp = "git push";
      gs = "git status";

      # Jujutsu
      j = "jj";

      # Utilities
      lg = "lazygit";
      top = "btop";
      weather = "curl wttr.in";
    };

    extraEnv = ''
      $env.config.show_banner = false
      $env.config.edit_mode = "vi"

      $env.config.history = {
        file_format: sqlite
        max_size: 100_000
        sync_on_enter: true
        isolation: false
      }

      $env.config.completions = {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
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

      $env.config.filesize = {
        unit: binary
        show_unit: true
        precision: 1
      }

      $env.config.rm.always_trash = false
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
        sudo nix-collect-garbage --delete-older-than 14d
        nix-collect-garbage --delete-older-than 14d
      }

      def nix-generations [] {
        nix profile history --profile /nix/var/nix/profiles/system
      }

      def syslog [
        --boot (-b)
        --errors (-e)
      ] {
        if $errors {
          journalctl --user -b -p warning
        } else if $boot {
          journalctl -b
        } else {
          journalctl --user -f
        }
      }

      def y [...args] {
        let temporary_file = (
          mktemp
          | str trim
        )

        yazi ...$args --cwd-file $temporary_file

        let cwd = (
          open $temporary_file
          | str trim
        )

        if (
          $cwd
          | is-not-empty
        ) and $cwd != $env.PWD {
          cd $cwd
        }

        rm -f $temporary_file
      }
    '';
  };
}
